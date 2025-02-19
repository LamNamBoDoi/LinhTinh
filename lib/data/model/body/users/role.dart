
class Role{
  int? id;
  String? name;
  String? authority;

  Role(this.id, this.name, this.authority);
  Role.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    authority = json['authority'];
  }
  Map<String, dynamic> toJson(){
    return {
      'id':id,
      'name':name,
      'authority':authority
    };
  }
}