import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timesheet/controller/post_controller.dart';
import 'package:timesheet/data/model/body/post/post.dart';
import 'package:timesheet/screen/tabs/posting/widget/comment_input_widget.dart';
import 'package:timesheet/screen/tabs/posting/widget/comment_item.dart';

class CommentScreen extends StatefulWidget {
  const CommentScreen({super.key, required this.post});
  final Post post;

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  late TextEditingController _commentController;

  @override
  void initState() {
    super.initState();
    _commentController = TextEditingController();
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50), // Chiều cao của AppBar
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
          child: AppBar(
            backgroundColor: Theme.of(context).secondaryHeaderColor,
            centerTitle: true,
            actions: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: GestureDetector(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: Colors.blue,
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: Icon(
                          Get.find<PostController>().checkLike(widget.post)
                              ? Icons.thumb_up
                              : Icons.thumb_up_alt_outlined,
                          color: Colors.blue,
                          size: 20),
                    ),
                  ),
                ),
              )
            ],
            title: Text(
              "comment".tr,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ),
      body: GetBuilder<PostController>(
        builder: (controller) {
          Post? updatedPost = controller.postsCurrent.firstWhere(
            (p) => p.id == widget.post.id,
            orElse: () => widget.post,
          );

          return Stack(
            children: [
              Column(
                children: [
                  SizedBox(
                    height: 5,
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: updatedPost.comments.length,
                      itemBuilder: (BuildContext context, int index) {
                        if (index >= updatedPost.comments.length) {
                          return const SizedBox.shrink();
                        }
                        final comment = updatedPost.comments[index];
                        return CommentItem(comment: comment);
                      },
                    ),
                  ),
                  CommentInputWidget(
                    commentController: _commentController,
                    post: widget.post,
                    postController: controller,
                  ),
                ],
              ),
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
