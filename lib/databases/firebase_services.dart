import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:book_store/models/user.dart';
import 'package:book_store/userProvider.dart';

enum QueryStatus { successful, failed }

class QueryResult<T> {
  QueryStatus? status;
  T? data;
  dynamic error;

  QueryResult({this.status, this.data, this.error});
}

abstract class Serializable {
  Map<String, dynamic> toJson();
}

class FirebaseServices {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  final usersRef = FirebaseFirestore.instance
      .collection('BOOK_STORE_Account')
      .withConverter<User>(
        fromFirestore: (snapshot, _) => User.fromJson(snapshot.data()!),
        toFirestore: (customer, _) => customer.toJson(),
      );


  Future<QueryResult<User>?> getUser({required String email}) async {
    QueryResult<User>? result;
    return await usersRef
        .where("email", isEqualTo: email)
        .get()
        .then((snapshot) {
      var userSnapShot = snapshot.docs;

      User? data;
      if (userSnapShot.isNotEmpty) {
        data = userSnapShot.first.data();
        data.id = userSnapShot.first.id;
        //data.id=
        print(data.id);
      }

      var status = QueryStatus.successful;

      result = QueryResult(
        status: status,
        data: data,
      );
      return result;
    }).catchError((error) {
      if (kDebugMode) {
        print("Failed to get user: $error");
      }
      var status = QueryStatus.failed;
      var errorMsg = error;
      result = QueryResult(status: status, error: errorMsg);

      return result;
    });
  }
  



  Future<QueryResult<User>?>? saveUser({required User user}) async {
    QueryResult<User>? result;

    //
    await usersRef.add(user).then((value) {
      result = QueryResult(status: QueryStatus.successful);
    }).catchError((error) {
      if (kDebugMode) {
        print("Failed to add user: $error");
      }
      result?.status = QueryStatus.failed;
      result?.error = error;
    });

    return result;
  }

  Future<QueryResult<User>?> updateUser({required User customer}) async {
    QueryResult<User>? result;
    print(customer.id);

    //
    await usersRef.doc(customer.id).update(customer.toJson()).then((value) {
      result = QueryResult(status: QueryStatus.successful);
    }).catchError((error) {
      if (kDebugMode) {
        print("Failed to update user: $error");
      }
      result?.status = QueryStatus.failed;
      result?.error = error;
    });

    return result;
  }
  Future<void> addProduct(
      double price,
      String description,
      String productName,
      String picture,
      String collectionName,
      String? id) async {
    var user = <String, dynamic>{
      "price": price,
      "picture": picture,
      "description": description,
      "productName": productName,
    };
    await FirebaseFirestore.instance
        .collection("pashewRestaurantManagerAccount")
        .doc(id)
        .collection(collectionName)
        .doc()
        .set(user);
  }
}



enum QueryStatuses { successful, failed }

class QueryResults<T> {
  QueryStatuses? status;
  T? data;
  dynamic error;

  QueryResults({this.status, this.data, this.error});
}



class ProductServices {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  BookProvider? productProvider;

  final usersRef = FirebaseFirestore.instance
      .collection('pashewRestaurantManagerAccount')
      .doc().
  collection("Products")
      .withConverter<Book>(
    fromFirestore: (snapshot, _) => Book.fromJson(snapshot.data()!),
    toFirestore: (product, _) => product.toJson(),
  );


  Future<QueryResults<Book>?> getProduct({required String bookName,required String id}) async {
    QueryResults<Book>? result;
    return await  FirebaseFirestore.instance
        .collection('Books_Catalogue')
        .doc(id).
    collection("Books")
        .withConverter<Book>(
      fromFirestore: (snapshot, _) => Book.fromJson(snapshot.data()!),
      toFirestore: (product, _) => product.toJson(),
    )
        .where("bookName", isEqualTo: bookName)
        .get()
        .then((snapshot) {
      var userSnapShot = snapshot.docs;

      Book? data;
      if (userSnapShot.isNotEmpty) {
        data = userSnapShot.first.data();
        data.id = userSnapShot.first.id;
        //data.id=
        print(data.id);
      }

      var status = QueryStatuses.successful;

      result = QueryResults(
        status: status,
        data: data,
      );
      return result;
    }).catchError((error) {
      if (kDebugMode) {
        print("Failed to get user: $error");
      }
      var status = QueryStatuses.failed;
      var errorMsg = error;
      result = QueryResults(status: status, error: errorMsg);

      return result;
    });
  }

  Future<QueryResults<Book>?>? saveUser({required Book product,id}) async {
    QueryResults<Book>? result;

    //
    FirebaseFirestore.instance
        .collection('Books_Catalogue')
        .doc(id).
    collection("Books")
        .withConverter<Book>(
      fromFirestore: (snapshot, _) => Book.fromJson(snapshot.data()!),
      toFirestore: (product, _) => product.toJson(),
    ).add(product).then((value) {
      result = QueryResults(status: QueryStatuses.successful);
    }).catchError((error) {
      if (kDebugMode) {
        print("Failed to add user: $error");
      }
      result?.status = QueryStatuses.failed;
      result?.error = error;
    });

    return result;
  }

  Future<QueryResults<Book>?> updateProduct({required Book product,required id}) async {
    QueryResults<Book>? result;
    print(product.id);

    //
    await  FirebaseFirestore.instance
        .collection('Books_Catalogue')
        .doc(id).
    collection("Books")
        .withConverter<Book>(
      fromFirestore: (snapshot, _) => Book.fromJson(snapshot.data()!),
      toFirestore: (product, _) => product.toJson(),
    ).doc(product.id).update(product.toJson()).then((value) {
      result = QueryResults(status: QueryStatuses.successful);
    }).catchError((error) {
      if (kDebugMode) {
        print("Failed to update user: $error");
      }
      result?.status = QueryStatuses.failed;
      result?.error = error;
    });

    return result;
  }

}


// class FirebaseAppCheckHelper {
//   FirebaseAppCheckHelper._();
//
//   static Future initialise() async {
//     await FirebaseAppCheck.instance.activate(
//       webRecaptchaSiteKey: 'recaptcha-v3-site-key',
//       androidProvider: _androidProvider(),
//     );
//   }
//
//   static AndroidProvider _androidProvider() {
//     if (kDebugMode) {
//       return AndroidProvider.debug;
//     }
//
//     return AndroidProvider.playIntegrity;
//   }
// }
