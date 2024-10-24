import 'dart:convert'; // chuyển đổi json với đối tượng dart
import 'dart:developer'; // sử dụng log trong debug
import 'dart:typed_data'; // làm việc với dữ liệu kiểu số nguyên
import 'package:flutter/foundation.dart' as foundation; // kiểm tra chế độ debug
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/request/request.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/app_constants.dart';
import '../model/error_response.dart';
// apiclient thực hiện yêu cầu HTTP đến api
// GetxService sử dụng cho các dịch vụ hoặc đối tượng cần giữ trạng thái trong toàn bộ ứng dụng
// Header: Chứa thông tin về kiểu token (ví dụ: JWT, Bearer) và thuật toán mã hóa được sử dụng.

// Payload: Chứa dữ liệu thực tế, thường là thông tin người dùng như ID, quyền truy cập, thời gian hết hạn (expiration), và các thông tin tùy chỉnh khác.

// Signature: Được tạo ra bằng cách mã hóa header và payload với một khóa bí mật. Phần này giúp đảm bảo rằng token không bị thay đổi và xác thực nguồn gốc của nó.

// Get vs Post
//    - Get: yêu cầu dữ liệu, cần tham số truy vấn
//    - Post: gửi dữ liệu; dữ liệu gửi trong phần body
class ApiClient extends GetxService {
  final String appBaseUrl; // địa chỉ cơ sở
  final SharedPreferences sharedPreferences;
  static final String noInternetMessage = 'connection_to_api_server_failed'.tr;
  final int timeoutInSeconds = 90;

  String token = "";
  Map<String, String> _mainHeaders = {}; // thông tin header cho yêu cầu HTTP
  // header: thông tin bổ sung trong yêu cầu và phản hổi: kiểu dữ liệu, thông tin xác thực, thông tin trình duyện

  ApiClient({required this.appBaseUrl, required this.sharedPreferences}) {
    // khởi tạo token từ
    token = sharedPreferences.getString(AppConstants.TOKEN) ??
        "Basic Y29yZV9jbGllbnQ6c2VjcmV0";
    if (foundation.kDebugMode) {
      // kiểm tra xem có đang chạy trong chế độ gỡ lỗi không
      log('Token: $token');
    }
    updateHeader(
      token,
      null,
      sharedPreferences.getString(AppConstants.LANGUAGE_CODE),
      0,
    );
    // cập nhật tiêu đề với nội dung, token, ngôn ngữ
  }

  void updateHeader(
      String token, List<int>? zoneIDs, String? languageCode, int moduleID) {
    Map<String, String> header = {
      'Content-Type': 'application/json; charset=utf-8',
      AppConstants.LOCALIZATION_KEY:
          languageCode ?? AppConstants.languages[0].languageCode,
      'Authorization': token
    };
    header.addAll({AppConstants.MODULE_ID: moduleID.toString()});
    _mainHeaders = header;
  }

  Future<Response> getData(String uri,
      {Map<String, dynamic>? query, Map<String, String>? headers}) async {
    try {
      if (foundation.kDebugMode) {
        log('====> API Call: $uri\nHeader: $_mainHeaders');
      }
      http.Response response = await http
          .get(
            Uri.parse(appBaseUrl + uri).replace(queryParameters: query),
            //tạo 1 đối tượng Uri từ một chuỗi
            //chuỗi truy vấn là phần để gửi thông tin đến máy chủ nằm sau ?
            //replace để sửa đổi các thành phần của đối tượng Uri mà ko cần tạo mới
            headers: headers ?? _mainHeaders,
          )
          .timeout(Duration(seconds: timeoutInSeconds));
      return handleResponse(response, uri);
    } catch (e) {
      log('------------${e.toString()}');
      return Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  Future<Response> postData(
      String uri, dynamic body, Map<String, String>? headers) async {
    try {
      String requestBody = jsonEncode(body);
      if (foundation.kDebugMode) {
        log('====> API Call: $uri\nHeader: $_mainHeaders');
        log('====> API Body: $requestBody');
      }
      http.Response response = await http
          .post(
            Uri.parse(appBaseUrl + uri),
            body: body,
            headers: _mainHeaders,
          )
          .timeout(Duration(seconds: timeoutInSeconds));
      return handleResponse(response, uri);
    } catch (e) {
      return Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  Future<Response> postDataLogin(
      String uri, dynamic body, Map<String, String>? headers) async {
    try {
      if (foundation.kDebugMode) {
        log('====> API Call: $uri\nHeader: ${headers ?? _mainHeaders}');
        log('====> API Body: $body');
      }
      http.Response response = await http
          .post(
            Uri.parse(appBaseUrl + uri),
            body: body,
            headers: headers,
          )
          .timeout(Duration(seconds: timeoutInSeconds));
      return handleResponse(response, uri);
    } catch (e) {
      return Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  Future<Response> postMultipartData(
      String uri, Map<String, String> body, List<MultipartBody> multipartBody,
      {required Map<String, String>? headers}) async {
    try {
      if (foundation.kDebugMode) {
        log('====> API Call: $uri\nHeader: $_mainHeaders');
        log('====> API Body: $body with ${multipartBody.length} picture');
      }
      http.MultipartRequest request =
          http.MultipartRequest('POST', Uri.parse(appBaseUrl + uri));
      request.headers.addAll(headers ?? _mainHeaders);
      for (MultipartBody multipart in multipartBody) {
        Uint8List list = await multipart.file.readAsBytes();
        request.files.add(http.MultipartFile(
          multipart.key,
          multipart.file.readAsBytes().asStream(),
          list.length,
          filename: '${DateTime.now().toString()}.png',
        ));
      }
      request.fields.addAll(body);
      http.Response response =
          await http.Response.fromStream(await request.send());
      return handleResponse(response, uri);
    } catch (e) {
      return Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  Future<Response> putData(String uri, dynamic body,
      {Map<String, String>? headers}) async {
    try {
      if (foundation.kDebugMode) {
        log('====> API Call: $uri\nHeader: $_mainHeaders');
        log('====> API Body: $body');
      }
      http.Response response = await http
          .put(
            Uri.parse(appBaseUrl + uri),
            body: jsonEncode(body),
            headers: headers ?? _mainHeaders,
          )
          .timeout(Duration(seconds: timeoutInSeconds));
      return handleResponse(response, uri);
    } catch (e) {
      return Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  Future<Response> deleteData(String uri,
      {Map<String, String>? headers}) async {
    try {
      if (foundation.kDebugMode) {
        log('====> API Call: $uri\nHeader: $_mainHeaders');
      }
      http.Response response = await http
          .delete(
            Uri.parse(appBaseUrl + uri),
            headers: headers ?? _mainHeaders,
          )
          .timeout(Duration(seconds: timeoutInSeconds));
      return handleResponse(response, uri);
    } catch (e) {
      return Response(statusCode: 1, statusText: noInternetMessage);
    }
  }
  // hàm xử lý phản hồi từ 1 yêu cầu HTTP
  Response handleResponse(http.Response response, String uri) {
    dynamic body;
    try {
      body = jsonDecode(utf8.decode(response.bodyBytes));
    } catch (e) {
      log(e.toString());
    }
    Response response0 = Response(
      body: body ?? response.body,
      bodyString: response.body.toString(),
      request: Request(
          headers: response.request!.headers,
          method: response.request!.method,
          url: response.request!.url),
      headers: response.headers,
      statusCode: response.statusCode,
      statusText: response.reasonPhrase,
    );
    if (response0.statusCode != 200 &&
        response0.body != null &&
        response0.body is! String) {
      if (response0.body.toString().startsWith('{errors: [{code:')) {
        ErrorResponse errorResponse = ErrorResponse.fromJson(response0.body);
        response0 = Response(
            statusCode: response0.statusCode,
            body: response0.body,
            statusText: errorResponse.errors![0].message);
      } else if (response0.body.toString().startsWith('{message')) {
        response0 = Response(
            statusCode: response0.statusCode,
            body: response0.body,
            statusText: response0.body['message']);
      }
    } else if (response0.statusCode != 200 && response0.body == null) {
      response0 = Response(statusCode: 0, statusText: noInternetMessage);
    }
    if (foundation.kDebugMode) {
      ('====> API Response: [${response0.statusCode}] $uri\n${response0.body}');
    }
    return response0;
  }
}

class MultipartBody {
  String key;
  XFile file;

  MultipartBody(this.key, this.file);
}
