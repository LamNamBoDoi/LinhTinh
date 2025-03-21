import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:timesheet/controller/photo_controller.dart';
import 'package:timesheet/controller/post_controller.dart';
import 'package:timesheet/controller/user_controller.dart';
import 'package:timesheet/view/custom_snackbar.dart';

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
    bool isUploadSuccessful = true;
    if (content.isEmpty) {
      showCustomFlash("please_enter_content!".tr, context, isError: true);
      return;
    }
    if (photoController.selectedPhoto != null) {
      await photoController.uploadImageUrl().then((response) {
        if (response != 200) {
          showCustomFlash("please_select_another_photo".tr, context,
              isError: true);
          isUploadSuccessful = false;
        }
      });
    }
    if (isUploadSuccessful) {
      if (photoController.photo != null &&
          photoController.selectedPhoto != null) {
        // final media = [
        //   Media(
        //     contentSize: photo.contentSize,
        //     contentType: photo.contentType,
        //     extension: photo.extension,
        //     id: null,
        //     isVideo: photo.isVideo,
        //     name: photo.name,
        //     filePath: photo.filePath,
        //   )
        // ];
        // postController.createPost(content, userController.currentUser, media);
        showCustomSnackBar("Chưa đăng post với ảnh được, hãy xóa ảnh đi");
      } else {
        postController.createPost(content, userController.currentUser, []);
        Get.back();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Theme.of(context).secondaryHeaderColor,
          elevation: 0.5,
          title: Text("create_articles".tr,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              )),
          centerTitle: true,
          actions: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: GestureDetector(
                onTap: _submitPost,
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
                    child: Text(
                      "post".tr,
                      style: const TextStyle(
                        color: Colors.blue, // Màu chữ
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
        body: GetBuilder<PhotoController>(
          builder: (_) => Stack(
            children: [
              Column(
                children: [
                  _buildUserInfo(),
                  _buildPostInput(),
                  _buildSelectedImage(),
                  _buildAddPhotoButton(),
                ],
              ),
              if (photoController.isLoading)
                const Center(
                  child: CircularProgressIndicator(),
                ),
            ],
          ),
        ));
  }

  Widget _buildUserInfo() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundImage: (userController.currentUser.image != "" &&
                    userController.currentUser.image != null)
                ? NetworkImage(userController.currentUser
                    .getLinkImageUrl(userController.currentUser.image!))
                : AssetImage("assets/image/avatarDefault.jpg") as ImageProvider,
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
