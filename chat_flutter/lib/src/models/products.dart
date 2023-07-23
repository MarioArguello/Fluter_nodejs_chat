// To parse this JSON data, do
//
//     final product = productFromJson(jsonString);

import 'dart:convert';

Product productFromJson(String str) => Product.fromJson(json.decode(str));

String productToJson(Product data) => json.encode(data.toJson());

class Product {
  String? id;
  String? name;
  String? description;
  double? price;
  String? image1;
  String? image2;
  int? quantity_product;
  String? id_category;
  String? id_person;
  int? quantity;
  Product({
    this.id,
    this.name,
    this.description,
    this.price,
    this.image1,
    this.image2,
    this.quantity_product,
    this.id_category,
    this.id_person,
    this.quantity,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        price: json["price"].toDouble(),
        image1: json["image1"],
        image2: json["image2"],
        quantity_product: json["quantity_product"],
        id_category: json["id_category"],
        id_person: json["id_person"],
        quantity: json["quantity"],
      );
  static List<Product> fromJsonList(List<dynamic> jsonList) {
    List<Product> toList = [];
    jsonList.forEach((element) {
      Product product = Product.fromJson(element);
      toList.add(product);
    });
    return toList;
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "price": price,
        "image1": image1,
        "image2": image2,
        "quantity_product": quantity_product,
        "id_category": id_category,
        "id_person": id_person,
        "quantity": quantity,
      };
}
