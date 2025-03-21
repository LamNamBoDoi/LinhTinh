import 'package:timesheet/data/model/body/users/role.dart';
import 'package:timesheet/utils/app_constants.dart';

class User {
  int? id;
  String? username;
  bool? active;
  String? birthPlace;
  String? confirmPassword;
  String? displayName;
  String? dob;
  String? email;
  String? firstName;
  String? lastName;
  String? password;
  String? image;
  bool? changePass;
  bool? setPassword;
  List<Role>? roles;
  int? countDayCheckin;
  int? countDayTracking;
  String? gender;
  bool? hasPhoto;
  String? tokenDevice;
  String? university;
  int? year;

  User({
    this.id,
    this.username,
    this.active,
    this.birthPlace,
    this.confirmPassword,
    this.displayName,
    this.dob,
    this.email,
    this.firstName,
    this.lastName,
    this.password,
    this.changePass,
    this.setPassword,
    this.roles,
    this.image,
    this.countDayCheckin,
    this.countDayTracking,
    this.gender,
    this.hasPhoto,
    this.tokenDevice,
    this.university,
    this.year,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      active: json['active'],
      birthPlace: json['birthPlace'],
      confirmPassword: json['confirmPassword'],
      displayName: json['displayName'],
      dob: json['dob'],
      email: json['email'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      password: json['password'],
      image: json['image'],
      changePass: json['changePass'],
      setPassword: json['setPassword'],
      roles: List<Role>.from(json['roles']?.map((e) => Role.fromJson(e))),
      countDayCheckin: json['countDayCheckin'],
      countDayTracking: json['countDayTracking'],
      gender: json['gender'],
      hasPhoto: json['hasPhoto'],
      tokenDevice: json['tokenDevice'],
      university: json['university'],
      year: json['year'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'active': active,
      'birthPlace': birthPlace,
      'confirmPassword': confirmPassword,
      'displayName': displayName,
      'dob': dob,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'password': password,
      'image': image,
      'changePass': changePass,
      'setPassword': setPassword,
      'roles': roles?.map((role) => role.toJson()).toList(),
      'countDayCheckin': countDayCheckin,
      'countDayTracking': countDayTracking,
      'gender': gender,
      'hasPhoto': hasPhoto,
      'tokenDevice': tokenDevice,
      'university': university,
      'year': year,
    };
  }

  String getLinkImageUrl(String typeImage) {
    String newUrl = typeImage.replaceAll(" ", "%20").replaceAll(":", "%3A");
    return "${AppConstants.BASE_URL}${AppConstants.GET_IMAGE_BY_NAME}$newUrl";
  }

  bool isEqual(User other) {
    return id == other.id &&
        username == other.username &&
        active == other.active &&
        // birthPlace == other.birthPlace &&
        displayName == other.displayName &&
        // dob == other.dob &&
        email == other.email &&
        // firstName == other.firstName &&
        // lastName == other.lastName &&
        password == other.password &&
        image == other.image &&
        // changePass == other.changePass &&
        // setPassword == other.setPassword &&
        // roles == other.roles &&
        gender == other.gender &&
        // hasPhoto == other.hasPhoto &&
        tokenDevice == other.tokenDevice &&
        university == other.university &&
        year == other.year;
  }
}
