import 'package:get/get.dart';

import '../modules/AddFood/bindings/add_food_binding.dart';
import '../modules/AddFood/views/add_food_view.dart';
import '../modules/Auth/bindings/auth_binding.dart';
import '../modules/Auth/views/auth_view.dart';
import '../modules/Auth/views/register_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;
  static const String login = '/login';
  static const String register = '/register';

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: login,
      page: () => const AuthView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: register,
      page: () => const RegisterView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: _Paths.ADD_FOOD,
      page: () => const AddFoodView(),
      binding: AddFoodBinding(),
    ),
  ];
}
