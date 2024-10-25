import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/app/modules/Auth/controllers/auth_controller.dart';
import 'package:myapp/app/modules/Auth/views/loading_view.dart';
import 'package:myapp/app/routes/app_pages.dart';
import 'package:myapp/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final authC = Get.put(AuthController(), permanent: true);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: authC.streamAuthStatus,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          print(snapshot);
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Dapur Mama',
            theme: ThemeData(
              primarySwatch: Colors.orange,
              textTheme: GoogleFonts.latoTextTheme(
                Theme.of(context).textTheme,
              ).apply(
                bodyColor: Colors.black,
                displayColor: Colors.black,
              ),
            ),
            initialRoute: snapshot.data != null ? Routes.HOME : AppPages.login,
            getPages: AppPages.routes,
          );
        }
        return LoadingView();
      },
    );
  }
}
