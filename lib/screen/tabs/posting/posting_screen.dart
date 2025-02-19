import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timesheet/controller/post_controller.dart';
import 'package:timesheet/data/model/body/post/post.dart';
import 'package:timesheet/screen/tabs/posting/create_post_screen.dart';
import 'package:timesheet/screen/tabs/posting/post_card_screen.dart';

class PostingScreen extends StatefulWidget {
  const PostingScreen({super.key});

  @override
  _PostingScreenState createState() => _PostingScreenState();
}

class _PostingScreenState extends State<PostingScreen> {
  final ScrollController _scrollController = ScrollController();
  late PostController postController;
  bool isLoadingMore = false;
  @override
  void initState() {
    super.initState();
    postController = Get.find<PostController>();

    // Tải bài post ban đầu
    postController.resetListPost();

    _scrollController.addListener(() {
      // Kiểm tra khi người dùng cuộn tới cuối danh sách
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (!isLoadingMore) {
          loadMorePosts();
        }
      }
    });
  }

  // Hàm tải thêm bài post mới
  void loadMorePosts() async {
    setState(() {
      isLoadingMore = true;
    });

    // Gọi API hoặc phương thức để tải thêm dữ liệu
    postController.currentPage += 1;
    await postController.getNewPosts();

    setState(() {
      isLoadingMore = false;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Bảng tin",
              style: TextStyle(
                color: Colors.blue[800],
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey[200],
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.search, color: Colors.black),
                    onPressed: () {},
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey[200],
                  ),
                  child: IconButton(
                    icon:
                        const Icon(Icons.add_box_outlined, color: Colors.blue),
                    onPressed: () {
                      Get.to(() => CreatePostScreen());
                    },
                  ),
                ),
              ],
            )
          ],
        ),
      ),
      body: GetBuilder<PostController>(
        builder: (controller) {
          return Stack(
            children: [
              RefreshIndicator(
                onRefresh: () async {
                  controller.resetListPost();
                },
                child: ListView.builder(
                  physics: const ClampingScrollPhysics(),
                  controller: _scrollController,
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  itemCount: controller.postsCurrent.length,
                  itemBuilder: (context, index) {
                    Post post = controller.postsCurrent[index];
                    return PostCard(
                      post: post,
                      postController: controller,
                    );
                  },
                ),
              ),

              // Hiển thị vòng xoay loading ngay giữa màn hình
              if (controller.isLoading)
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(
                      child:
                          CircularProgressIndicator(color: Colors.blueAccent),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
