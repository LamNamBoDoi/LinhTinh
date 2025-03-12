import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timesheet/controller/post_controller.dart';
import 'package:timesheet/data/model/body/post/post.dart';

class CommentInputWidget extends StatelessWidget {
  const CommentInputWidget(
      {super.key,
      required this.postController,
      required this.commentController,
      required this.post});
  final PostController postController;
  final TextEditingController commentController;
  final Post post;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 20,
            child: Icon(Icons.person, size: 25),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: commentController,
              decoration: InputDecoration(
                hintText: "write_a_comment".tr,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send, color: Colors.blue),
            onPressed: () {
              String commentText = commentController.text;
              if (commentText.isNotEmpty) {
                postController.commentPost(commentText, post);
                commentController.clear();
              }
            },
          ),
        ],
      ),
    );
  }
}
