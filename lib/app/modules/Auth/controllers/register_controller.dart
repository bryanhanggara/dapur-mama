import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/app/components/snackbar.dart';
import 'package:myapp/app/routes/app_pages.dart';

class RegisterController extends GetxController {
  var obsecureText = true.obs;
  final Snackbar snackbar = Snackbar();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;

  void register(String email, String password) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      snackbar.snackbarAuth("Berhasil", "Selamat akun mu sudah terdaftar");
      Get.toNamed(Routes.HOME);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        snackbar.snackbarAuth(
            "Stop!", "Password yang digunakan terlalu singkat");
      } else if (e.code == 'email-already-in-use') {
        snackbar.snackbarAuth("Cek lagi", "Email sudah terdaftar");
      }
      print(e.code);
    } catch (e) {
      print(e);
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
