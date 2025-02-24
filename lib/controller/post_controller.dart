import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:timesheet/controller/user_controller.dart';
import 'package:timesheet/data/api/api_checker.dart';
import 'package:timesheet/data/model/body/post/comment.dart';
import 'package:timesheet/data/model/body/post/like.dart';
import 'package:timesheet/data/model/body/post/media.dart';
import 'package:timesheet/data/model/body/post/post.dart';
import 'package:timesheet/data/model/body/post/post_response.dart';
import 'package:timesheet/data/model/body/users/user.dart';
import 'package:timesheet/data/repository/post_repo.dart';

class PostController extends GetxController implements GetxService {
  final PostRepo repo;
  PostController({required this.repo});

  int currentPage = 1;
  bool _isLastPage = false;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  int currentPageByUser = 1;
  bool isLastPageByUser = false;

  List<Post> _posts = [];
  List<Post> _postsByUser = [];
  List<Post> _postsCurrent = [];
  List<Post> get posts => _posts;
  List<Post> get postsCurrent => _postsCurrent;
  List<Post> get postsByUser => _postsByUser;

  Future<void> resetListPost(String keyWord) async {
    _isLastPage = false;
    currentPage = 1;
    _postsCurrent.clear();
    getNewPosts(keyWord);
  }

  bool checkLike(Post post) {
    UserController userController = Get.find<UserController>();

    return post.likes
            ?.any((like) => like.user?.id == userController.currentUser.id) ??
        false;
  }

  Future<void> getNewPosts(String keyWord) async {
    _isLoading = true;
    update();

    Response response = await repo.getNewPosts(keyWord, currentPage, 5, 0);
    debugPrint("okeoke: ${response.statusCode}");
    if (response.statusCode == 200) {
      var responseData = response.body;

      if (responseData is Map<String, dynamic>) {
        PostResponse convertPostResponse = PostResponse.fromJson(responseData);

        _posts = convertPostResponse.content;
        _postsCurrent.addAll(_posts);
      } else {
        throw Exception("Unexpected response format");
      }
    } else {
      ApiChecker.checkApi(response);
    }
    _isLoading = false;
    update();
  }

  Future<void> likePost(Post post) async {
    _isLoading = true;
    update();
    UserController userController = Get.find<UserController>();

    Like like = Like(
      id: 0,
      date: DateTime.now()
          .millisecondsSinceEpoch, // Chuyển đổi thời gian hiện tại thành int (milliseconds since epoch)
      type: 0,
      user: userController.currentUser,
    );

    Response response = await repo.likePost(like, post);
    debugPrint("Like: ${response.statusCode}");
    if (response.statusCode == 200) {
      updatePost(post);
    } else {
      ApiChecker.checkApi(response);
    }
    _isLoading = false;
    update();
  }

  Future<void> commentPost(String content, Post post) async {
    _isLoading = true;
    update();
    UserController userController = Get.find<UserController>();
    Comment comment = Comment(
        id: 0,
        content: content,
        date: DateTime.now().millisecondsSinceEpoch,
        user: userController.currentUser);

    Response response = await repo.commentPost(comment, post);
    debugPrint("Comment: ${response.statusCode}");
    if (response.statusCode == 200) {
      updatePost(post);
    } else {
      ApiChecker.checkApi(response);
    }
    _isLoading = false;
    update();
  }

  Future<void> createPost(String content, User user, List<Media> media) async {
    _isLoading = true;
    update();
    Post post = Post(
        content: content,
        date: DateTime.now().millisecondsSinceEpoch,
        id: 0,
        likes: [],
        comments: [],
        media: media,
        user: user);
    print(post.media.first.name);
    Response response = await repo.createPost(post);
    debugPrint("CreatePost: ${response.statusCode}");
    if (response.statusCode == 200) {
      resetListPost("");
    } else {
      ApiChecker.checkApi(response);
    }
    _isLoading = false;
    update();
  }

  void updatePost(Post post) async {
    Response response = await repo.getNewPosts("", currentPage, 5, 0);
    if (response.statusCode == 200) {
      var responseData = response.body;

      if (responseData is Map<String, dynamic>) {
        PostResponse convertPostResponse = PostResponse.fromJson(responseData);

        _posts = convertPostResponse.content;
        Post postUpdate = _posts.firstWhere(
          (e) => e.id == post.id,
        );
        _postsCurrent = _postsCurrent.map((p) {
          return p.id == postUpdate.id ? postUpdate : p;
        }).toList();
        update();
      } else {
        throw Exception("Unexpected response format");
      }
    } else {
      ApiChecker.checkApi(response);
    }
  }
}
