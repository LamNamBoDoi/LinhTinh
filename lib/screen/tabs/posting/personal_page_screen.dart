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
  final UserController userController = Get.find<UserController>();
  final PostController postController = Get.find<PostController>();

  RxBool selectPost = true.obs;
  User? user;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchUserPost();
    });
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
  Widget build(BuildContext context) {
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
              const SizedBox(height: 20),
              CircleAvatar(
                radius: 50,
                backgroundImage: (user!.image != "" && user!.image != null)
                    ? NetworkImage(user!
                        .getLinkImageUrl(user!.image!)) // Hiển thị ảnh từ URL
                    : AssetImage("assets/image/avatarDefault.jpg")
                        as ImageProvider,
              ),
              const SizedBox(height: 12),
              Text(
                user!.displayName ?? "username".tr,
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              const Divider(height: 5, thickness: 5),
              Obx(() => _buildTabBar()),
              const Divider(height: 1, thickness: 1),
              Expanded(
                  child: Obx(() => selectPost.value
                      ? (widget.isMyPost == true
                          ? _buildPostList()
                          : const SizedBox())
                      : UserInfoWidget(
                          user: user!,
                        ))),
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
        if (controller.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (postController.postsByUser.isEmpty) {
          return Center(
              child: Text("no_posts".tr,
                  style: TextStyle(fontSize: 16, color: Colors.grey)));
        }
        return ListView.builder(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          itemCount: postController.postsByUser.length,
          itemBuilder: (context, index) {
            final post = postController.postsByUser[index];
            return PostItem(post: post, postController: postController);
          },
        );
      },
    );
  }
}
