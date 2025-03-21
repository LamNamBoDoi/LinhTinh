import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timesheet/controller/post_controller.dart';
import 'package:timesheet/controller/user_controller.dart';
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
    final UserController userController = Get.find<UserController>();

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10)),
          border: Border.all(color: Theme.of(context).secondaryHeaderColor)),
      child: Row(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundImage: (userController.currentUser.image != "" &&
                    userController.currentUser.image != null)
                ? NetworkImage(userController.currentUser
                    .getLinkImageUrl(userController.currentUser.image!))
                : AssetImage("assets/image/avatarDefault.jpg") as ImageProvider,
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
