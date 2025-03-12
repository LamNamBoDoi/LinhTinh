import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:timesheet/data/api/api_checker.dart';
import 'package:timesheet/data/model/body/photo.dart';
import 'package:timesheet/data/repository/photo_repo.dart';
import 'package:timesheet/view/custom_snackbar.dart';

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
      print(selectedPhoto);
      update();
    }
  }

  void resetPickImage() {
    selectedPhoto = null;
    _photo = null;
    update();
  }

  void updateSelectedPhoto(File file) {
    selectedPhoto = file;
    update();
  }

  Future<int> uploadImageUrl() async {
    isLoading = true;
    update();

    if (selectedPhoto == null ||
        selectedPhoto!.lengthSync() / 1024 / 1024 > 1) {
      showCustomSnackBar("please_select_another_photo".trParams(),
          isError: true);
      return 400;
    }
    print(
        'Kích thước của file: ${(selectedPhoto!.lengthSync() / 1024 / 1024)} MB');

    try {
      print("Bắt đầu upload ảnh...");
      Response response = await repo.uploadImageUrl(selectedPhoto!);
      print("Upload thành công, mã trạng thái: ${response.statusCode}");
      debugPrint("UploadImage: ${response.statusCode}");

      if (response.statusCode == 200) {
        _photo = Photo.fromJson(response.body);
      } else {
        ApiChecker.checkApi(response);
      }
      isLoading = false;
      update();
      return response.statusCode!;
    } catch (e) {
      print("Lỗi khi upload ảnh: $e");
      return 500;
    }
  }
}
