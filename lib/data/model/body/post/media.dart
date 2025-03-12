import 'package:timesheet/utils/app_constants.dart';

class Media {
  int? id;
  String? contentType;
  int? contentSize;
  String? name;
  String? extension;
  bool? isVideo;
  String? filePath;

  Media({
    required this.contentSize,
    required this.contentType,
    required this.extension,
    required this.filePath,
    required this.id,
    required this.isVideo,
    required this.name,
  });

  factory Media.fromJson(Map<String, dynamic> json) {
    return Media(
      contentSize: json['contentSize'],
      contentType: json['contentType'],
      extension: json['extension'],
      filePath: json['filePath'],
      id: json['id'],
      isVideo: json['isVideo'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['contentSize'] = contentSize;
    data['contentType'] = contentType;
    data['extension'] = extension;
    data['filePath'] = filePath;
    data['id'] = id;
    data['name'] = name;
    return data;
  }

  String getLinkImageUrl() {
    return "${AppConstants.BASE_URL}${AppConstants.GET_IMAGE_BY_NAME}$name.png";
  }
}
