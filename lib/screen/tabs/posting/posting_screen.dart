import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timesheet/controller/post_controller.dart';
import 'package:timesheet/screen/tabs/posting/create_post_screen.dart';
import 'package:timesheet/screen/tabs/posting/widget/port_item.dart';
import 'package:timesheet/screen/tabs/posting/search_screen.dart';

class PostingScreen extends StatefulWidget {
  const PostingScreen({super.key});

  @override
  _PostingScreenState createState() => _PostingScreenState();
}

class _PostingScreenState extends State<PostingScreen> {
  final ScrollController _scrollController = ScrollController();
  final PostController postController = Get.find<PostController>();
  bool isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !isLoadingMore) {
      _loadMorePosts();
    }
  }

  Future<void> _loadMorePosts() async {
    setState(() => isLoadingMore = true);
    postController.currentPage += 1;
    await postController.getNewPosts(isUpdate: false);
    setState(() => isLoadingMore = false);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).secondaryHeaderColor,
        elevation: 0.5,
        title: Text(
          "message_board".tr,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        actions: [
          _buildIconButton(
              Icons.search, Colors.black, () => Get.to(() => SearchScreen())),
          _buildIconButton(Icons.add_box_outlined, Colors.blue,
              () => Get.to(() => CreatePostScreen())),
        ],
      ),
      body: GetBuilder<PostController>(initState: (_) async {
        await postController.resetListPost("");
      }, builder: (controller) {
        return Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    physics: const ClampingScrollPhysics(),
                    controller: _scrollController,
                    padding: const EdgeInsets.all(10),
                    itemCount: controller.postsCurrent.length,
                    itemBuilder: (context, index) => PostItem(
                      isPersonPage: false,
                      post: controller.postsCurrent[index],
                      postController: controller,
                    ),
                  ),
                ),
              ],
            ),
            if (controller.isLoading)
              const Center(
                  child: CircularProgressIndicator(color: Colors.blueAccent)),
          ],
        );
      }),
    );
  }

  Widget _buildIconButton(IconData icon, Color color, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: CircleAvatar(
        backgroundColor: Colors.grey[200],
        child: IconButton(icon: Icon(icon, color: color), onPressed: onTap),
      ),
    );
  }
}
