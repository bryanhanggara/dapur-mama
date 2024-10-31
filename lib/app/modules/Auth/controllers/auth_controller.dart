import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/app/components/snackbar.dart';
import 'package:myapp/app/modules/Auth/views/auth_view.dart';
import 'package:myapp/app/routes/app_pages.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  var obsecureText = true.obs;
  FirebaseAuth auth = FirebaseAuth.instance;

  final Snackbar snackbar = Snackbar();

  Stream<User?> get streamAuthStatus => auth.authStateChanges();

  @override
  void onInit() {
    super.onInit();
    autoLogin();
  }

  void autoLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isLoggedIn = prefs.getBool('isLoggedIn');

    if (isLoggedIn == true) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.offAllNamed(Routes.HOME);
      });
    }
  }

  void login(String email, String password) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      Get.offAllNamed(Routes.HOME);
    } on FirebaseException catch (e) {
      if (e.code == 'invalid-email') {
        snackbar.snackbarAuth("Gagal", "Email tidak sesuai format");
      } else if (e.code == "invalid-credential") {
        snackbar.snackbarAuth('Gagal', 'Password atau email tidak cocok');
      } else if (e.code == "too-many-requests") {
        snackbar.snackbarAuth('Maaf', "Terlalu banyak mencoba, coba nanti");
      }
      print(e.code);
    } catch (e) {
      print(e);
    }
  }

  void logout() async {
    await auth.signOut();
    Get.off(() => AuthView());
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
