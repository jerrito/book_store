import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';


class PrimarySnackBar {
  PrimarySnackBar(BuildContext context) {
    fToast.init(context);
    _context = context;
  }

  FToast fToast = FToast();
  late BuildContext _context;

  displaySnackBar({required String message, Color? backgroundColor}) {
    Widget toast = Container(
      padding: EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 16,
      ),
      width: MediaQuery.of(_context).size.width,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.green,
      ),
      child: SizedBox(
        width: MediaQuery.of(_context).size.width,
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
        ),
      ),
    );

    fToast.showToast(
        child: toast,
        toastDuration: const Duration(seconds: 5),
        positionedToastBuilder: (context, child) {
          return Positioned(
            top: 100.0,
            left: 0,
            child: child,
          );
        });
  }
}
