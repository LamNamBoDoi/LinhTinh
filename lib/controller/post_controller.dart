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
import 'package:timesheet/view/custom_snackbar.dart';

class PostController extends GetxController implements GetxService {
  final PostRepo repo;
  PostController({required this.repo});

  int currentPage = 1;
  // bool _isLastPage = false;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  int currentPageByUser = 1;
  bool isLastPageByUser = false;

  List<Post> _posts = [];
  final List<Post> _postsByUser = [];
  List<Post> _postsCurrent = [];
  List<Post> get posts => _posts;
  List<Post> get postsCurrent => _postsCurrent;
  List<Post> get postsByUser => _postsByUser;

  Future<void> resetListPost(String keyWord) async {
    // _isLastPage = false;
    currentPage = 1;
    if (keyWord == "") {
      _postsCurrent.clear();
      _posts.clear();
      await getNewPosts(isUpdate: false);
    } else {
      _postsByUser.clear();
      await getNewPostsByUser(keyWord, isUpdate: false);
    }
  }

  bool checkLike(Post post) {
    UserController userController = Get.find<UserController>();

    return post.likes
            ?.any((like) => like.user?.id == userController.currentUser.id) ??
        false;
  }

  Future<void> getNewPosts({required bool isUpdate}) async {
    _isLoading = true;
    update();

    Response response = isUpdate
        ? await repo.getNewPosts("", 1, 5 * currentPage, 0)
        : await repo.getNewPosts("", currentPage, 5, 0);
    debugPrint("getNewPosts: ${response.statusCode}");
    if (response.statusCode == 200) {
      var responseData = response.body;
      if (responseData is Map<String, dynamic>) {
        PostResponse convertPostResponse = PostResponse.fromJson(responseData);
        _posts = convertPostResponse.content;
        if (isUpdate) {
          _postsCurrent.replaceRange(0, _postsCurrent.length, _posts);
        } else {
          _postsCurrent.addAll(_posts);
        }
      } else {
        throw Exception("Unexpected response format");
      }
    } else {
      ApiChecker.checkApi(response);
    }
    _isLoading = false;
    update();
  }

  Future<void> getNewPostsByUser(
    String keyWord, {
    required bool isUpdate,
  }) async {
    _isLoading = true;
    update();
    Response response = isUpdate
        ? await repo.getNewPostsByUser("", 1, 5 * currentPage, 0)
        : await repo.getNewPostsByUser("", currentPage, 5, 0);

    debugPrint("okeoke: ${response.statusCode}");
    if (response.statusCode == 200) {
      var responseData = response.body;
      if (responseData is Map<String, dynamic>) {
        PostResponse convertPostResponse = PostResponse.fromJson(responseData);
        _posts = convertPostResponse.content;
        if (isUpdate) {
          _postsByUser.replaceRange(0, _postsByUser.length, _posts);
        } else {
          _postsByUser.addAll(_posts);
        }
      } else {
        throw Exception("Unexpected response format");
      }
    } else {
      ApiChecker.checkApi(response);
    }
    _isLoading = false;
    update();
  }

  Future<void> likePost(Post post, {required bool isPersonPage}) async {
    _isLoading = true;
    update();
    UserController userController = Get.find<UserController>();

    Like like = Like(
      id: 0,
      date: DateTime.now().millisecondsSinceEpoch,
      type: 0,
      user: userController.currentUser,
    );

    Response response = await repo.likePost(like, post);
    debugPrint("Like: ${response.statusCode}");
    if (response.statusCode == 200) {
      isPersonPage
          ? await getNewPostsByUser("", isUpdate: true)
          : await getNewPosts(isUpdate: true);
    } else {
      ApiChecker.checkApi(response);
    }
    _isLoading = false;
    update();
  }

  Future<void> dislikePost(Post post) async {
    _isLoading = true;
    update();
    User user = Get.find<UserController>().currentUser;
    List<Like>? likes = post.likes;
    print(likes?.length);
    likes?.removeWhere((like) => like.user!.id == user.id);
    print(likes?.length);
    post.likes = likes;
    print(post.likes);
    updatePost(post);
    _isLoading = false;
    update();
  }

  Future<void> commentPost(String content, Post post,
      {required bool isPersonPage}) async {
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
      isPersonPage
          ? await getNewPostsByUser("", isUpdate: true)
          : await getNewPosts(isUpdate: true);
    } else {
      ApiChecker.checkApi(response);
    }
    _isLoading = false;
    update();
  }

  Future<void> updatePost(Post post) async {
    _isLoading = true;
    update();
    Response response = await repo.updatePost(post);
    debugPrint("updatePost: ${response.statusCode}");
    if (response.statusCode == 200) {
      getNewPosts(isUpdate: true);
    } else {
      ApiChecker.checkApi(response);
    }
    _isLoading = false;
    update();
  }

  Future<void> createPost(String content, User user, List<Media>? media) async {
    _isLoading = true;
    update();
    Post post = Post(
        content: content,
        date: DateTime.now().millisecondsSinceEpoch,
        id: 0,
        likes: [],
        comments: [],
        media: media ?? [],
        user: user);
    Response response = await repo.createPost(post);
    debugPrint("CreatePost: ${response.statusCode}");
    if (response.statusCode == 200) {
      resetListPost("");
      showCustomFlash("create_post_successfully".tr, Get.context!,
          isError: false);
    } else {
      showCustomFlash("create_post_failed".tr, Get.context!, isError: true);
      ApiChecker.checkApi(response);
    }
    _isLoading = false;
    update();
  }
}
