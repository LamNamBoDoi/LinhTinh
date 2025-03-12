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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GetBuilder<PostController>(
          builder: (controller) {
            Post? updatedPost = controller.postsCurrent.firstWhere(
              (p) => p.id == widget.post.id,
              orElse: () => widget.post,
            );

            return Stack(
              children: [
                Column(
                  children: [
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
      ),
    );
  }
}
