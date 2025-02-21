import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:timesheet/data/api/api_checker.dart';
import 'package:timesheet/data/model/body/photo.dart';
import 'package:timesheet/data/repository/photo_repo.dart';

class PhotoController extends GetxController implements GetxService {
  final PhotoRepo repo;
  PhotoController({required this.repo});

  bool isLoading = false;
  File? selectedPhoto;
  Photo? _photo;

  Photo? get photo => _photo;
  Future<void> pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source);
    if (image != null) {
      selectedPhoto = File(image.path);
      update();
    }
  }

  Future<int> uploadImageUrl() async {
    isLoading = true;
    update();

    if (selectedPhoto == null || selectedPhoto!.lengthSync() / 1024 / 1024 > 1)
      return 400;
    print(
        'Kích thước của file: ${(selectedPhoto!.lengthSync() / 1024 / 1024)} MB');

    Response response = await repo.uploadImageUrl(selectedPhoto!);
    debugPrint("UploadImage: ${response.statusCode}");

    if (response.statusCode == 200) {
      print(response.body);
      _photo = Photo.fromJson(response.body);
      Get.snackbar("Thành công", "Upload ảnh thành công!");
    } else {
      Get.snackbar("Lỗi", "Upload thất bại: ${response.body}");
      ApiChecker.checkApi(response);
    }
    isLoading = false;
    update();
    return response.statusCode!;
  }
}
