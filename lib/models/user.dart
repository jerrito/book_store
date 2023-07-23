import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:book_store/databases/firebase_services.dart';


class User implements Serializable {
  String? fullName;
  String? registrationDate;
  String? email;
  String? password;
  String? id;
  String? image;
  

  User({
    this.fullName,
    this.registrationDate,
    this.id,
    this.email,
    this.password,
    this.image,
 
  });
  factory User.fromJson(Map? json) => User(
        id: json?["id"],
        fullName: json?["fullName"],
        registrationDate: json?["registrationDate"],
        email: json?["email"],
        password: json?["password"],
        image: json?["image"],
       
      );
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      "fullName": fullName,
      "registrationDate": registrationDate,
      "password": password,
      "email": email,
      "image": image,
    
    };
  }

  static User fromString(String userString) {
    return User.fromJson(jsonDecode(userString));
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}

class Book implements Serializable {
  String? bookName;
  String? category;
  String? description;
  String? picture;
  String? id;
  double? price;
  String? file;

  Book({
    this.bookName,
    this.description,
    this.id,
    this.picture,
    this.price,
    this.category,
    this.file


  });
  factory Book.fromJson(Map? json) => Book(
    id: json?["id"],
    bookName: json?["productName"],
    description: json?["description"],
    picture: json?["picture"],
    price: json?["price"],
    category: json?["category"],
    file: json?["file"],

  );
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      "productName": bookName,
      "description": description,
      "picture": picture,
      "price": price,
      "category":category,
      "file":file,

    };
  }

  static Book fromString(String userString) {
    return Book.fromJson(jsonDecode(userString));
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}