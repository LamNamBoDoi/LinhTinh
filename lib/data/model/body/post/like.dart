import 'package:timesheet/data/model/body/users/user.dart';

class Like {
  int id;
  int? date;
  int? type;
  User? user;

  Like({
    required this.id,
    this.date,
    this.type,
    this.user,
  });

  factory Like.fromJson(Map<String, dynamic> json) {
    return Like(
      date: json['date'],
      id: json['id'],
      type: json['type'],
      user: User.fromJson(json['user']),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['date'] = date;
    data['type'] = type;
    data['user'] = user?.toJson();
    return data;
  }
}
