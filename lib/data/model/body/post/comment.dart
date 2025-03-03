import 'package:timesheet/data/model/body/users/user.dart';

class Comment {
  int id;
  String content;
  int date;
  User? user;

  Comment(
      {required this.id, required this.content, required this.date, this.user});

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      content: json['content'],
      date: json['date'],
      user: User.fromJson(json['user']),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['content'] = content;
    data['date'] = date;
    data['user'] = user?.toJson();
    return data;
  }
}
