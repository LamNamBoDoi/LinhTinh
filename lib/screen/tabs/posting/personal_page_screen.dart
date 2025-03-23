import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timesheet/controller/post_controller.dart';
import 'package:timesheet/controller/user_controller.dart';
import 'package:timesheet/data/model/body/users/user.dart';
import 'package:timesheet/screen/tabs/posting/widget/port_item.dart';
import 'package:timesheet/screen/tabs/posting/widget/tab_button_widget.dart';
import 'package:timesheet/screen/tabs/posting/widget/user_info_widget.dart';

class PersonalPageScreen extends StatefulWidget {
  final int userId;
  final String displayName;
  final bool isMyPost;

  const PersonalPageScreen({
    super.key,
    required this.userId,
    required this.displayName,
    required this.isMyPost,
  });

  @override
  State<PersonalPageScreen> createState() => _PersonalPageScreenState();
}

class _PersonalPageScreenState extends State<PersonalPageScreen> {
  final ScrollController _scrollController = ScrollController();
  final UserController userController = Get.find<UserController>();
  final PostController postController = Get.find<PostController>();
  bool isLoadingMore = false;
  double previousOffset = 0;
  RxBool selectPost = true.obs;
  double hightHead = 220;
  User? user;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchUserPost();
    });
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    double currentOffset = _scrollController.offset;

    // if (currentOffset > previousOffset) {
    //   print("Đang cuộn xuống");
    // } else if (currentOffset < previousOffset) {
    //   print("Đang cuộn lên");
    // }
    if (currentOffset > 10) {
      // print("Đã cuộn xuống quá 100px");
      setState(
        () => hightHead = 0,
      );
    } else if (currentOffset < 20) {
      // print("Đã cuộn lên dưới 50px");
      setState(
        () => hightHead = 230,
      );
    }

    previousOffset = currentOffset;
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !isLoadingMore) {
      _loadMorePosts();
    }
  }

  Future<void> _loadMorePosts() async {
    setState(() => isLoadingMore = true);
    postController.currentPage += 1;
    await postController.getNewPostsByUser(widget.displayName, isUpdate: false);
    setState(() => isLoadingMore = false);
  }

  Future<void> _fetchUserPost() async {
    try {
      user = await userController.getUserById(widget.userId);
      await postController.resetListPost(widget.displayName);
    } catch (e) {
      debugPrint("Error loading user: $e");
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mqWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).secondaryHeaderColor,
        title: Text("personal_page".tr),
        centerTitle: true,
      ),
      body: GetBuilder<UserController>(
        builder: (controller) {
          if (controller.loading || user == null) {
            return const Center(child: CircularProgressIndicator());
          }
          return Column(
            children: [
              AnimatedContainer(
                duration:
                    const Duration(milliseconds: 500), // Thời gian animation
                curve: Curves.easeInOut,
                width: mqWidth,
                height: hightHead,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: (user!.image != "" &&
                                user!.image != null)
                            ? NetworkImage(user!.getLinkImageUrl(user!.image!))
                            : const AssetImage("assets/image/avatarDefault.jpg")
                                as ImageProvider,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        user!.displayName ?? "username".tr,
                        style: const TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 5),
                      const Divider(height: 5, thickness: 5),
                      Obx(() => _buildTabBar()),
                    ],
                  ),
                ),
              ),
              const Divider(height: 1, thickness: 1),
              SizedBox(
                height: 10,
              ),
              Expanded(
                child: Obx(() => selectPost.value
                    ? (widget.isMyPost == true
                        ? _buildPostList()
                        : Center(
                            child: Text("no_posts".tr,
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.grey))))
                    : UserInfoWidget(
                        user: user!,
                      )),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          TabButtonWidget(
              title: "articles".tr,
              isSelected: selectPost.value,
              onTap: () => selectPost.value = true),
          TabButtonWidget(
              title: "info".tr,
              isSelected: !selectPost.value,
              onTap: () => selectPost.value = false),
        ],
      ),
    );
  }

  Widget _buildPostList() {
    return GetBuilder<PostController>(
      builder: (controller) {
        return Stack(
          children: [
            ListView.builder(
              physics: const ClampingScrollPhysics(),
              controller: _scrollController,
              padding: const EdgeInsets.all(10),
              itemCount: controller.postsByUser.length,
              itemBuilder: (context, index) {
                final post = controller.postsByUser[index];
                return PostItem(
                  post: post,
                  postController: controller,
                  isPersonPage: true,
                );
              },
            ),
            if (controller.isLoading)
              const Center(child: CircularProgressIndicator())
          ],
        );
      },
    );
  }
}
