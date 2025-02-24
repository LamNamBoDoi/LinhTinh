import 'package:timesheet/utils/app_constants.dart';

class Photo {
  final int id;
  final String contentType;
  final int contentSize;
  final String name;
  final String? extension;
  final String filePath;
  final bool? isVideo;

  Photo({
    required this.id,
    required this.contentType,
    required this.contentSize,
    required this.name,
    this.extension,
    required this.filePath,
    this.isVideo,
  });

  // Chuyển đổi từ JSON sang đối tượng Photo
  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      id: json['id'] ?? 0,
      contentType: json['contentType'] ?? '',
      contentSize: json['contentSize'] ?? 0,
      name: json['name'] ?? '',
      extension: json['extension'],
      filePath: json['filePath'] ?? '',
      isVideo: json['isVideo'],
    );
  }

  // Chuyển đổi từ đối tượng Photo sang JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'contentType': contentType,
      'contentSize': contentSize,
      'name': name,
      'extension': extension,
      'filePath': filePath,
      'isVideo': isVideo,
    };
  }

  String getLinkImageUrl(String typeImage) {
    String newUrl = typeImage.replaceAll(" ", "%20").replaceAll(":", "%3A");
    return "${AppConstants.BASE_URL}${AppConstants.GET_IMAGE_BY_NAME}$newUrl";
  }
}
