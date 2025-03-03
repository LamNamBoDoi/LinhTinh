import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timesheet/controller/post_controller.dart';
import 'package:timesheet/controller/user_controller.dart';
import 'package:timesheet/data/model/body/users/user.dart';
import 'package:timesheet/screen/tabs/posting/post_card_screen.dart';

class PersonalPageScreen extends StatefulWidget {
  final int userId;
  final String displayName;
  const PersonalPageScreen(
      {super.key, required this.userId, required this.displayName});

  @override
  State<PersonalPageScreen> createState() => _PersonalPageScreenState();
}

class _PersonalPageScreenState extends State<PersonalPageScreen> {
  late User user;
  UserController userController = Get.find<UserController>();
  PostController postController = Get.find<PostController>();
  @override
  void initState() {
    super.initState();
    _fetchUserPost();
  }

  Future<void> _fetchUserPost() async {
    try {
      user = await userController.getUserById(widget.userId);
      await postController.resetListPost(widget.displayName);
      print(postController.postsByUser.length);
    } catch (e) {
      debugPrint("Error loading user: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Scaffold(body: GetBuilder<UserController>(builder: (controller) {
        if (controller.loading) {
          return const Center(child: CircularProgressIndicator());
        }
        return Column(
          children: [
            SizedBox(
              height: 40,
            ),
            CircleAvatar(
              radius: 50,
              backgroundImage: user.image != null
                  ? NetworkImage(user.getLinkImageUrl(user.image!))
                  : AssetImage("assets/image/avatarDefault.jpg")
                      as ImageProvider,
            ),
            const SizedBox(height: 20), // Để ảnh đại diện không bị che
            Text(
              user.displayName ?? "User Name",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),

            Divider(
              height: 1,
              thickness: 1,
            ),

            Expanded(child: GetBuilder<PostController>(builder: (controller) {
              if (controller.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              return ListView.builder(
                physics: const ClampingScrollPhysics(),
                itemCount: postController.postsByUser.length,
                itemBuilder: (context, index) {
                  final post = postController.postsByUser[index];
                  return PostCard(post: post, postController: postController);
                },
              );
            })),
          ],
        );
      })),
    );
  }
}
