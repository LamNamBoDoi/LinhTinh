import 'package:timesheet/data/model/body/post/post.dart';
import 'package:timesheet/data/model/body/users/pageable.dart';
import 'package:timesheet/data/model/body/users/sort.dart';

class PostResponse {
  List<Post> content;
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

  PostResponse({
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

  factory PostResponse.fromJson(Map<String, dynamic> json) {
    return PostResponse(
      content: (json['content'] as List).map((c) => Post.fromJson(c)).toList(),
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
}
