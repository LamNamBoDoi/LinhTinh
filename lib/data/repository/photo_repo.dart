import 'dart:io';
import 'package:get/get.dart';
import '../../utils/app_constants.dart';
import '../api/api_client.dart';

class PhotoRepo {
  final ApiClient apiClient;
  PhotoRepo({required this.apiClient});

  Future<Response> uploadImageUrl(File file) async {
    return apiClient.postFileMultipartData(
      uri: AppConstants.UPLOAD_FILE,
      file: file,
      body: {},
    );
  }

  // Future<Response> uploadImageUrl(List<MultipartBody> file) async {
  //   return apiClient.postMultipartData(
  //     AppConstants.UPLOAD_FILE,
  //     {},
  //     file,
  //     null,
  //   );
  // }
}
