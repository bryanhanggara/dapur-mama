import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:myapp/app/modules/Auth/controllers/auth_controller.dart';
import 'package:myapp/app/routes/app_pages.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  Widget button(
      {required String text, required int index, required String image}) {
    return Obx(
      () => GestureDetector(
        onTap: () {
          controller.selecetedValueIndex.value = index;
        },
        child: Container(
          margin: EdgeInsets.only(right: 5, left: 5),
          height: 40,
          width: 100,
          decoration: BoxDecoration(
            color: controller.selecetedValueIndex.value == index
                ? Colors.orange
                : Colors.white,
            borderRadius: BorderRadius.circular(
              ScreenUtil().setWidth(10),
            ),
            border: Border.all(
              color: Colors.orange,
              width: 1,
            ),
          ),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  image,
                  height: 20,
                  width: 20,
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  text,
                  style: TextStyle(
                    color: controller.selecetedValueIndex.value == index
                        ? Colors.white
                        : Colors.black,
                    fontSize: ScreenUtil().setSp(11),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find();
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo.jpg',
              width: 70,
              fit: BoxFit.cover,
            ),
          ],
        ),
        actions: [
          Container(
            width: 250,
            padding: const EdgeInsets.all(5.0),
            margin: const EdgeInsets.only(right: 10, top: 10),
            child: TextField(
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color.fromARGB(121, 211, 210, 210),
                hintText: "Cari Resep..",
                contentPadding: const EdgeInsets.symmetric(vertical: 6),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.transparent),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.orange),
                ),
                prefixIcon: const Icon(Icons.search),
              ),
            ),
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Katalog Resep Makanan",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    authController.logout();
                  },
                  icon: Icon(
                    Icons.logout,
                    size: 30,
                    color: Colors.orange,
                  ),
                ),
              ],
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ...List.generate(
                    controller.buttonText.length,
                    (index) => button(
                      text: controller.buttonText[index],
                      index: index,
                      image: controller.iconButton[index],
                    ).paddingSymmetric(vertical: 10),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Flexible(
              child: Obx(
                () => StreamBuilder(
                  stream: controller.readRecipe(controller
                      .buttonText[controller.selecetedValueIndex.value]),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Colors.orange,
                        ),
                      );
                    }
                    if (snapshot.hasError) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/images/error.webp",
                              width: 100,
                              height: 100,
                            ),
                            Text("Terjadi Eror"),
                          ],
                        ),
                      );
                    }
                    if (snapshot.hasData &&
                        snapshot.data != null &&
                        snapshot.data!.isNotEmpty) {
                      return GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          childAspectRatio: 0.95,
                        ),
                        itemBuilder: (_, index) => GestureDetector(
                          onTap: () {
                            Get.toNamed(Routes.DETAIL_FOOD,
                                arguments: snapshot.data?[index].id);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(
                                ScreenUtil().setWidth(10),
                              ),
                              border: Border.all(
                                color: Colors.grey[300]!,
                                width: 1.h,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(
                                      ScreenUtil().setWidth(10),
                                    ),
                                    topRight: Radius.circular(
                                        ScreenUtil().setWidth(10)),
                                  ),
                                  child: CachedNetworkImage(
                                    imageUrl:
                                        snapshot.data?[index].images ?? "",
                                    height: 100,
                                    width: 200,
                                    fit: BoxFit.cover,
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                  ),
                                ),
                                Flexible(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        snapshot.data?[index].nama ?? "",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Spacer(),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.alarm,
                                                color: Colors.grey[600],
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                "${snapshot.data?[index].waktuPembuatan} Menit",
                                                style: TextStyle(
                                                  fontSize:
                                                      ScreenUtil().setSp(12),
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.grey[600],
                                                ),
                                              ),
                                            ],
                                          ),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 5,
                                              vertical: 5,
                                            ),
                                            height: 20,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(5.r),
                                              ),
                                              color: controller.getColor(
                                                snapshot.data?[index].jenis ??
                                                    "",
                                              ),
                                            ),
                                            child: Text(
                                              "${snapshot.data?[index].jenis}",
                                              style: TextStyle(
                                                fontSize: 9.sp,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                    ],
                                  ).paddingOnly(
                                    top: 10,
                                    left: 10,
                                    right: 10,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        itemCount: snapshot.data?.length,
                      );
                    } else {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/images/not-found.webp",
                              width: 100,
                              height: 100,
                            ),
                            Text("data tidak ditemukan"),
                          ],
                        ),
                      );
                    }
                  },
                ),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed(Routes.ADD_FOOD);
        },
        backgroundColor: Colors.orange,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
