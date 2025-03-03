import 'package:timesheet/data/model/body/users/user.dart';

class Notify {
  Notify({this.id, this.body, this.date, this.title, this.type, this.user});
  int? id;
  String? body;
  int? date;
  String? title;
  String? type;
  User? user;

  factory Notify.fromJson(Map<String, dynamic> json) {
    return Notify(
      id: json['id'],
      body: json['body'],
      date: json['date'],
      title: json['title'],
      type: json['type'],
      user: json['user'] != null ? User.fromJson(json['user']) : User(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['body'] = body;
    data['date'] = date;
    data['title'] = title;
    data['type'] = type;
    data['user'] = user?.toJson();
    return data;
  }
}
