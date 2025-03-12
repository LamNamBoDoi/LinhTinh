import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:timesheet/controller/photo_controller.dart';
import 'package:timesheet/controller/post_controller.dart';
import 'package:timesheet/controller/user_controller.dart';
import 'package:timesheet/data/model/body/post/media.dart';

class CreatePostScreen extends StatefulWidget {
  @override
  _CreatePostScreenState createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final TextEditingController _postTextController = TextEditingController();
  final UserController userController = Get.find<UserController>();
  final PostController postController = Get.find<PostController>();
  final PhotoController photoController = Get.find<PhotoController>();

  @override
  void initState() {
    super.initState();
    Get.find<PhotoController>().resetPickImage();
  }

  void _submitPost() async {
    String content = _postTextController.text.trim();

    if (content.isEmpty) {
      Get.snackbar("error".tr, "please_enter_content!".tr,
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }
    if (photoController.selectedPhoto != null) {
      await photoController.uploadImageUrl();
    }
    final photo = photoController.photo;
    if (photo != null) {
      final media = [
        Media(
          contentSize: photo.contentSize,
          contentType: photo.contentType,
          extension: photo.extension,
          id: null,
          isVideo: photo.isVideo,
          name: photo.name,
          filePath: photo.filePath,
        )
      ];
      // postController.createPost(content, userController.currentUser, media);
      print("Media: " + media.toString());
    } else {
      postController.createPost(content, userController.currentUser, []);
    }

    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: Text("create_articles".tr,
            style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black)),
        actions: [
          TextButton(
            onPressed: _submitPost,
            child: Text("post".tr,
                style: TextStyle(color: Colors.blue, fontSize: 16)),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildUserInfo(),
          _buildPostInput(),
          _buildSelectedImage(),
          _buildAddPhotoButton(),
        ],
      ),
    );
  }

  Widget _buildUserInfo() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundImage: userController.currentUser.image != null
                ? NetworkImage(userController.currentUser
                    .getLinkImageUrl(userController.currentUser.image!))
                : null,
            child: userController.currentUser.image == null
                ? const Icon(Icons.person, size: 30)
                : null,
          ),
          const SizedBox(width: 10),
          Text(
            userController.currentUser.displayName ?? "user".tr,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildPostInput() {
    return Expanded(
      child: TextField(
        controller: _postTextController,
        maxLines: null,
        decoration: InputDecoration(
          hintText: "what_are_you_thinking?".tr,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(10),
        ),
      ),
    );
  }

  Widget _buildSelectedImage() {
    return GetBuilder<PhotoController>(
      builder: (controller) {
        if (controller.selectedPhoto == null) return SizedBox.shrink();

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.file(
                  File(controller.selectedPhoto!.path),
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: GestureDetector(
                  onTap: () {
                    controller.selectedPhoto = null;
                    controller.update();
                  },
                  child: Container(
                    height: 30,
                    width: 30,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black54,
                    ),
                    child:
                        const Icon(Icons.close, color: Colors.white, size: 18),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAddPhotoButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Center(
        child: ElevatedButton.icon(
          onPressed: () => photoController.pickImage(ImageSource.gallery),
          icon: const Icon(Icons.photo_library, color: Colors.white, size: 28),
          label: Text("add_photo".tr,
              style: const TextStyle(fontSize: 16, color: Colors.white)),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            elevation: 3,
          ),
        ),
      ),
    );
  }
}
