import 'dart:convert';

Category categoryFromJson(String str) => Category.fromJson(json.decode(str));

String categoryToJson(Category data) => json.encode(data.toJson());

class Category {
  String? id;
  String? name;
  String? description;
  String? id_person;
  Category({this.id, this.name, this.description, this.id_person});

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        id_person: json["id_person"],
      );

  static List<Category> fromJsonList(List<dynamic> jsonList) {
    List<Category> toList = [];
    jsonList.forEach((element) {
      Category category = Category.fromJson(element);
      toList.add(category);
    });
    return toList;
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "id_person": id_person,
      };
}
