import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class Snackbar {
  void snackbarAuth(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.orange[300],
      colorText: Colors.white,
      borderRadius: 10,
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      animationDuration: Duration(milliseconds: 300),
      duration: Duration(seconds: 3),
      isDismissible: true,
      icon: Icon(
        Icons.info,
        color: Colors.white,
      ),
    );
  }
}
