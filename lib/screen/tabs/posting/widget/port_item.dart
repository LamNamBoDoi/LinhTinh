import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timesheet/controller/post_controller.dart';
import 'package:timesheet/controller/user_controller.dart';
import 'package:timesheet/data/model/body/post/post.dart';
import 'package:timesheet/screen/tabs/posting/comment_screen.dart';
import 'package:intl/intl.dart';
import 'package:timesheet/screen/tabs/posting/personal_page_screen.dart';
import 'package:timesheet/view/custom_snackbar.dart';

class PostItem extends StatelessWidget {
  final Post post;
  final PostController postController;
  final bool isPersonPage;

  const PostItem(
      {Key? key,
      required this.post,
      required this.postController,
      required this.isPersonPage})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Padding(
        padding: EdgeInsets.only(top: 10, right: 10, left: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () => Get.to(() => PersonalPageScreen(
                      isMyPost: post.user.id ==
                              Get.find<UserController>().currentUser.id
                          ? true
                          : false,
                      userId: post.user.id!,
                      displayName: post.user.displayName!)),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 25,
                        backgroundImage:
                            (post.user.image != "" && post.user.image != null)
                                ? NetworkImage(
                                    post.user.getLinkImageUrl(post.user.image!))
                                : AssetImage("assets/image/avatarDefault.jpg")
                                    as ImageProvider,
                      ),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            post.user.displayName ?? "user".tr,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.black),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            DateFormat('dd/MM/yyyy HH:mm').format(
                                DateTime.fromMillisecondsSinceEpoch(post.date)),
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                const Icon(Icons.more_horiz, color: Colors.grey),
              ],
            ),
            SizedBox(height: 10),
            Text(
              post.content ?? "",
              style: const TextStyle(fontSize: 16, color: Colors.black),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      const WidgetSpan(
                        child:
                            Icon(Icons.thumb_up, size: 18, color: Colors.blue),
                      ),
                      TextSpan(
                        text: ' ${post.likes?.length.toString() ?? "0"}',
                        style: TextStyle(
                            fontSize: 16, color: Colors.black.withOpacity(0.5)),
                      ),
                    ],
                  ),
                ),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                          text: ' ${post.comments.length.toString()}',
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.black.withOpacity(0.5)),
                          children: [TextSpan(text: " " "comment".tr)]),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Divider(
              color: Theme.of(context).secondaryHeaderColor,
              height: 1,
              thickness: 1,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton.icon(
                  onPressed: () {
                    if (!postController.checkLike(post)) {
                      postController.likePost(post, isPersonPage: isPersonPage);
                    } else {
                      // postController.dislikePost(post);
                      showCustomSnackBar("Chưa xóa like được", isError: true);
                    }
                  },
                  icon: postController.checkLike(post)
                      ? const Icon(
                          Icons.thumb_up,
                          color: Colors.blue,
                        )
                      : Icon(
                          Icons.thumb_up_outlined,
                          color: Colors.black.withOpacity(0.5),
                        ),
                  label: Text(
                    "like".tr,
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.5),
                    ),
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            CommentScreen(
                          isPersonPage: isPersonPage,
                          post: post,
                        ),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          const begin = Offset(0.0, 1.0);
                          const end = Offset.zero;
                          const curve = Curves.easeInOut;
                          var tween = Tween(begin: begin, end: end)
                              .chain(CurveTween(curve: curve));
                          var offsetAnimation = animation.drive(tween);

                          return SlideTransition(
                              position: offsetAnimation, child: child);
                        },
                      ),
                    );
                  },
                  icon: Icon(Icons.comment_outlined, color: Colors.grey[600]),
                  label: Text(
                    "comment".tr,
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.5),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
