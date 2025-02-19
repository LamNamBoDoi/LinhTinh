import 'package:timesheet/data/model/body/users/pageable.dart';
import 'package:timesheet/data/model/body/users/sort.dart';
import 'package:timesheet/data/model/body/users/user.dart';

class PageableResponse {
  List<User> content;
  bool empty;
  bool first;
  bool last;
  int number;
  int numberOfElements;
  Pageable pageable;
  int size;
  Sort sort;
  int totalElements;
  int totalPages;

  PageableResponse({
    required this.content,
    required this.empty,
    required this.first,
    required this.last,
    required this.number,
    required this.numberOfElements,
    required this.pageable,
    required this.size,
    required this.sort,
    required this.totalElements,
    required this.totalPages,
  });

  factory PageableResponse.fromJson(Map<String, dynamic> json) {
    return PageableResponse(
      content: (json['content'] as List)
          .map((userJson) => User.fromJson(userJson))
          .toList(),
      empty: json['empty'],
      first: json['first'],
      last: json['last'],
      number: json['number'],
      numberOfElements: json['numberOfElements'],
      pageable: Pageable.fromJson(json['pageable']),
      size: json['size'],
      sort: Sort.fromJson(json['sort']),
      totalElements: json['totalElements'],
      totalPages: json['totalPages'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'content': content.map((user) => user.toJson()).toList(),
      'empty': empty,
      'first': first,
      'last': last,
      'number': number,
      'numberOfElements': numberOfElements,
      'pageable': pageable.toJson(),
      'size': size,
      'sort': sort.toJson(),
      'totalElements': totalElements,
      'totalPages': totalPages,
    };
  }
}
