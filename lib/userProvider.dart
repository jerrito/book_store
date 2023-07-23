import 'package:flutter/foundation.dart';
import 'package:book_store/databases/firebase_services.dart';
import 'package:book_store/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomerProvider extends ChangeNotifier {
  final SharedPreferences? preferences;
  final firebaseService = FirebaseServices();

  CustomerProvider({required this.preferences}) {
    var appUserString = preferences?.getString("app_user") ?? '';
    _appUser = appUserString.isNotEmpty ? User.fromString(appUserString) : null;
  }

  User? _appUser;
  User? get appUser => _appUser;

  set appUser(User? a) {
    _appUser = a;
    notifyListeners();

    preferences?.setString(
      "app_user",
      a?.toString() ?? '',
    );
  }

  Future<QueryResult<User>?>? getUser({required String email}) async {
    var result = await firebaseService.getUser(email: email);

    if (result?.status == QueryStatus.successful && result?.data != null) {
      appUser = result?.data;
    }

    return result;
  }



  Future<QueryResult<User>?>? updateUser({required User customer}) async {
    var result = await firebaseService.updateUser(customer: customer);

    if (result?.status == QueryStatus.successful) {
      await getUser(email: customer.registrationDate ?? "");
    }

    return result;
  }
}


class BookProvider extends ChangeNotifier {
  final SharedPreferences? preference;
  final firebaseService = FirebaseServices();

  BookProvider({required this.preference}) {
    var productTypeString = preference?.getString("type") ?? '';
        _type = productTypeString.isNotEmpty? Book.fromString(productTypeString) : null;
  }

  Book? _type;
  Book? get typeOf => _type;

  set typeOf(Book? a) {
    _type = a;
    notifyListeners();

    preference?.setString(
      "type",
      a?.toString() ?? '',
    );
  }

  Future<QueryResults<Book>?>? getProduct({required String productName,required String id}) async {
    var result = await ProductServices().getProduct(bookName: productName,id:id);

    if (result?.status == QueryStatuses.successful && result?.data != null) {
      typeOf = result?.data;
    }

    return result;
  }



  Future<QueryResults<Book>?>? updateProduct({required Book product, required id}) async {
    var result = await ProductServices().updateProduct(product: product,id:id);

    if (result?.status == QueryStatuses.successful) {
      await getProduct(productName: product.bookName ?? "", id: product.id ?? "");
    }

    return result;
  }
}
