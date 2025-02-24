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
  UserController userController = Get.find<UserController>();
  PostController postController = Get.find<PostController>();
  PhotoController photoController = Get.find<PhotoController>();
  List<Media> media = [];
  Future<void> _pickImage() async {
    photoController.pickImage(ImageSource.gallery);
  }

  void _submitPost() {
    String content = _postTextController.text.trim();

    if (content.isEmpty && photoController.selectedPhoto == null) {
      Get.snackbar("Lỗi", "Vui lòng nhập nội dung hoặc thêm ảnh!",
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }
    photoController.uploadImageUrl();
    media.add(Media(
      contentSize: photoController.photo!.contentSize,
      contentType: photoController.photo!.contentType,
      extension: photoController.photo!.extension,
      id: null,
      isVideo: photoController.photo!.isVideo,
      name: photoController.photo!.name,
      filePath: photoController.photo!.filePath,
    ));
    postController.createPost(content, userController.currentUser, media);
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
        title: const Text(
          "Tạo bài viết",
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        actions: [
          TextButton(
            onPressed: _submitPost,
            child: const Text("ĐĂNG",
                style: TextStyle(color: Colors.blue, fontSize: 16)),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundImage: userController.currentUser.image != null
                      ? NetworkImage(userController.currentUser.getLinkImageUrl(
                          userController
                              .currentUser.image!)) // Hiển thị ảnh từ URL
                      : null,
                  child: userController.currentUser.image == null
                      ? Icon(Icons.person, size: 30)
                      : null,
                ),
                const SizedBox(width: 10),
                Text(
                  userController.currentUser.displayName ?? "Người dùng",
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Expanded(
            child: TextField(
              controller: _postTextController,
              maxLines: null,
              decoration: const InputDecoration(
                hintText: "Bạn đang nghĩ gì?",
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(10),
              ),
            ),
          ),
          if (photoController.selectedPhoto != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.file(
                      File(photoController.selectedPhoto!.path),
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
                        setState(() {
                          media.clear();
                          photoController.selectedPhoto = null;
                        });
                      },
                      child: Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black54,
                        ),
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          SizedBox(
            height: 50,
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Center(
              child: ElevatedButton.icon(
                onPressed: _pickImage,
                icon: Icon(Icons.photo_library, color: Colors.white, size: 28),
                label: Text("Thêm ảnh",
                    style: TextStyle(fontSize: 16, color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 3,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
