import 'package:timesheet/data/model/body/post/comment.dart';

import '../users/user.dart';
import 'like.dart';
import 'media.dart';

class Post {
  int? id;
  String? content;
  int date;
  List<Like>? likes;
  List<Comment> comments;
  List<Media> media;
  User user;

  Post({
    required this.content,
    required this.date,
    required this.id,
    required this.likes,
    required this.comments,
    required this.media,
    required this.user,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      comments: json['comments'] == null
          ? []
          : List<Comment>.from(
              json['comments'].map((comment) => Comment.fromJson(comment))),
      content: json['content'],
      date: json['date'],
      id: json['id'],
      likes: json['likes'] == null
          ? []
          : List<Like>.from(
              json['likes']?.map((comment) => Like.fromJson(comment))),
      media: json['media'] == null
          ? []
          : List<Media>.from(
              json['media']?.map((comment) => Media.fromJson(comment))),
      user: User.fromJson(json['user']),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['content'] = content;
    data['date'] = date;
    data['likes'] = likes?.map((like) => like.toJson()).toList();
    data['comments'] = comments.map((comment) => comment.toJson()).toList();
    data['media'] = media.map((me) => me.toJson()).toList();
    data['user'] = user.toJson();
    return data;
  }
}
