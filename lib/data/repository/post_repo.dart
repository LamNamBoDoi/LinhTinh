import 'dart:convert';

import 'package:get/get.dart';
import 'package:timesheet/data/api/api_client.dart';
import 'package:timesheet/data/model/body/post/comment.dart';
import 'package:timesheet/data/model/body/post/like.dart';
import 'package:timesheet/data/model/body/post/post.dart';
import 'package:timesheet/utils/app_constants.dart';

class PostRepo {
  final ApiClient apiClient;
  PostRepo({required this.apiClient});

  Future<Response> getNewPosts(
      String keyWord, int pageIndex, int size, int status) async {
    return await apiClient.postData(
        AppConstants.GET_NEW_POSTS,
        jsonEncode({
          "keyWord": keyWord,
          "pageIndex": pageIndex,
          "size": size,
          "status": status
        }),
        null);
  }

  Future<Response> getNewPostsByUser(
      String keyWord, int pageIndex, int size, int status) async {
    return await apiClient.postData(
        AppConstants.GET_NEW_POSTS_BY_USER,
        jsonEncode({
          "keyWord": keyWord,
          "pageIndex": pageIndex,
          "size": size,
          "status": status
        }),
        null);
  }

  Future<Response> likePost(Like like, Post post) async {
    return await apiClient.postData(
        AppConstants.LIKE_POST + post.id.toString(),
        jsonEncode({
          "date": like.date,
          "id": like.id,
          "post": post,
          "type": like.type,
          "user": like.user,
        }),
        null);
  }

  Future<Response> updatePost(Post post) async {
    return await apiClient.postData(
        AppConstants.UPDATE_POST + post.id.toString(), jsonEncode(post), null);
  }

  Future<Response> commentPost(Comment comment, Post post) async {
    return await apiClient.postData(
        AppConstants.COMMENT_POST + post.id.toString(),
        jsonEncode({
          "content": comment.content,
          "date": comment.date,
          "id": comment.id,
          "post": post,
          "user": comment.user,
        }),
        null);
  }

  Future<Response> createPost(Post post) async {
    return await apiClient.postData(
        AppConstants.CREATE_POST, jsonEncode(post), null);
  }
}
