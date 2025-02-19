import 'package:timesheet/data/model/body/users/user.dart';

class TimeSheet {
  int? id;
  int? dateAttendance;
  String? message;
  String? ip;
  User? user;
  bool? offline;

  TimeSheet(
      {this.id,
      this.dateAttendance,
      this.message,
      this.ip,
      this.user,
      this.offline});

  factory TimeSheet.fromJson(Map<String, dynamic> json) {
    return TimeSheet(
      id: json['id'],
      dateAttendance: json['dateAttendance'],
      message: json['message'],
      ip: json['ip'],
      user: json['user'] != null ? User.fromJson(json['user']) : User(),
      offline: json['offline'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['dateAttendance'] = dateAttendance;
    data['message'] = message;
    data['ip'] = ip;
    data['user'] = user?.toJson();
    data['offline'] = offline;
    return data;
  }
}
