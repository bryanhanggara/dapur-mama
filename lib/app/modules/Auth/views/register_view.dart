import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:myapp/app/modules/Auth/controllers/register_controller.dart';

import '../controllers/auth_controller.dart';

class RegisterView extends GetView<AuthController> {
  const RegisterView({super.key});
  @override
  Widget build(BuildContext context) {
    final RegisterController controller = Get.find();

    return Scaffold(
        body: SingleChildScrollView(
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Image.asset(
                    'assets/images/register.webp',
                    width: 200,
                  ),
                ),
                const Text(
                  'Daftar',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: controller.emailController,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Colors.orange,
                      ),
                    ),
                    labelText: "Email",
                    prefixIcon: const Icon(Icons.email),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Obx(
                  () => TextField(
                    controller: controller.passwordController,
                    obscureText: controller.obsecureText.value,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Colors.orange,
                        ),
                      ),
                      labelText: "Password",
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        onPressed: () {
                          controller.obsecureText.value =
                              !controller.obsecureText.value;
                        },
                        icon: controller.obsecureText.value
                            ? const Icon(Icons.visibility)
                            : const Icon(Icons.visibility_off),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      controller.register(
                        controller.emailController.text,
                        controller.passwordController.text,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        )),
                    child: const Text(
                      "Daftar",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Sudah punya akun?"),
                    TextButton(
                      onPressed: () {
                        Get.toNamed('login');
                      },
                      child: const Text("Daftar"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
