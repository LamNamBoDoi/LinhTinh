import 'package:timesheet/data/model/body/users/sort.dart';

class Pageable {
  int offset;
  int pageNumber;
  int pageSize;
  bool paged;
  Sort sort;
  bool unpaged;

  Pageable({
    required this.offset,
    required this.pageNumber,
    required this.pageSize,
    required this.paged,
    required this.sort,
    required this.unpaged,
  });

  factory Pageable.fromJson(Map<String, dynamic> json) {
    return Pageable(
      offset: json['offset'],
      pageNumber: json['pageNumber'],
      pageSize: json['pageSize'],
      paged: json['paged'],
      sort: Sort.fromJson(json['sort']),
      unpaged: json['unpaged'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'offset': offset,
      'pageNumber': pageNumber,
      'pageSize': pageSize,
      'paged': paged,
      'sort': sort.toJson(),
      'unpaged': unpaged,
    };
  }
}
