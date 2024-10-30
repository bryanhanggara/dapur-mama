import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myapp/app/data/Food.dart';
import 'package:myapp/app/modules/home/controllers/home_controller.dart';
import 'package:myapp/app/routes/app_pages.dart';

import '../controllers/detail_food_controller.dart';

class DetailFoodView extends GetView<DetailFoodController> {
  const DetailFoodView({super.key});
  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.find();
    final String foodId = Get.arguments as String;

    return Scaffold(
      bottomNavigationBar: Container(
        height: 100,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 5,
              offset: Offset(0, -1),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  deleteMenu();
                },
                child: Container(
                    width: 150,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.delete_outline_outlined,
                          color: Colors.white,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Text("Hapus",
                            style: TextStyle(color: Colors.white))
                      ],
                    )),
              ),
              GestureDetector(
                onTap: () {
                  // editMenu(controller.food.id);
                  showUpdateModal(foodId);
                },
                child: Container(
                    width: 150,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.edit,
                          color: Colors.white,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Text("Edit",
                            style: TextStyle(color: Colors.white))
                      ],
                    )),
              ),
            ],
          ),
        ),
      ),
      body: FutureBuilder<DocumentSnapshot<Object?>>(
        future: controller.getFood(foodId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasData) {
            var data = snapshot.data!;
            controller.getFoodId(data.id);
            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 300,
                  backgroundColor: Colors.red,
                  pinned: true,
                  leading: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Material(
                          color: Colors.white,
                          child: InkWell(
                            onTap: () {
                              Get.back();
                            },
                            child: Icon(
                              Icons.arrow_back,
                              color: Colors.black,
                            ),
                          )),
                    ),
                  ),
                  bottom: PreferredSize(
                    preferredSize: Size.fromHeight(70),
                    child: Container(
                      width: double.infinity,
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              snapshot.data!['nama'],
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 5,
                              vertical: 5,
                            ),
                            height: 20,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: homeController.getColor(
                                snapshot.data!['jenis'],
                              ),
                            ),
                            child: Text(
                              snapshot.data!['jenis'],
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                    background: Image.network(
                      snapshot.data!['images'],
                      width: double.maxFinite,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: ColoredBox(
                    color: Colors.white,
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Waktu Pembuatan",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.timer,
                                color: Colors.orange,
                              ),
                              Text(
                                "${snapshot.data!["waktu_pembuatan"]} Menit",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey[500],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            snapshot.data!["deskripsi"],
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[500],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Resep dan Cara Membuat",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            snapshot.data!["resep"],
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            );
          } else {
            return const Center(child: Text("Data tidak ditemukan"));
          }
        },
      ),
    );
  }

  void showUpdateModal(String foodId) {
    controller.getFood(foodId).then((snapshot) {
      if (snapshot.exists) {
        final foodData = snapshot.data() as Map<String, dynamic>;
        Food food = Food.fromJson(foodData);

        // Buat controller untuk setiap field
        final TextEditingController namaController =
            TextEditingController(text: food.nama);
        final TextEditingController jenisController =
            TextEditingController(text: food.jenis);
        final TextEditingController deskripsiController =
            TextEditingController(text: food.deskripsi);
        final TextEditingController resepController =
            TextEditingController(text: food.resep);
        final TextEditingController waktuController =
            TextEditingController(text: food.waktuPembuatan.toString());

        // Tampilkan modal bottom sheet
        showModalBottomSheet(
          context: Get.context!,
          builder: (context) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: namaController,
                    decoration: InputDecoration(labelText: 'Nama'),
                  ),
                  TextField(
                    controller: jenisController,
                    decoration: InputDecoration(labelText: 'Jenis'),
                  ),
                  TextField(
                    controller: deskripsiController,
                    decoration: InputDecoration(labelText: 'Deskripsi'),
                  ),
                  TextField(
                    controller: resepController,
                    decoration: InputDecoration(labelText: 'Resep'),
                  ),
                  TextField(
                    controller: waktuController,
                    decoration:
                        InputDecoration(labelText: 'Waktu Pembuatan (menit)'),
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {},
                    child: Text('Simpan Perubahan'),
                  ),
                ],
              ),
            );
          },
        );
      } else {
        Get.snackbar("Error", "Data makanan tidak ditemukan");
      }
    }).catchError((error) {
      Get.snackbar("Error", "Terjadi kesalahan: $error");
    });
  }

  void deleteMenu() {
    Get.dialog(
      AlertDialog(
        title: const Text("Hapus"),
        content: const Text("data akan dihapus permanen"),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: Text("Batal"),
          ),
          TextButton(
            onPressed: () {
              controller.deleteMenu(controller.foodId.value);
              Get.offAllNamed(Routes.HOME);
              Get.snackbar(
                "Dihapus",
                "Data berhasil dihapus",
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.red,
                colorText: Colors.white,
                margin: const EdgeInsets.all(10),
              );
            },
            child: Text("Hapus"),
          ),
        ],
      ),
    );
  }

  // void editMenu(Food food, BuildContext context) {
  //   final image = XFile("").obs;
  //   final namaController = TextEditingController();
  //   final waktuPembuatanController = TextEditingController();
  //   final resepController = TextEditingController();
  //   final deskripsiController = TextEditingController();

  //   namaController.text = food.nama;
  //   waktuPembuatanController.text = food.waktuPembuatan.toString();
  //   resepController.text = food.resep;
  //   deskripsiController.text = food.deskripsi;

  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     backgroundColor: Colors.transparent,
  //     builder: (context) => Obx(() => Container(
  //           height: 0.9,
  //           padding: EdgeInsets.only(
  //               bottom: MediaQuery.of(context).viewInsets.bottom),
  //           decoration: BoxDecoration(
  //             color: Colors.white,
  //             borderRadius: BorderRadius.circular(10),
  //           ),
  //           child: SingleChildScrollView(
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               mainAxisSize: MainAxisSize.min,
  //               children: [
  //                 Row(
  //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                   children: [
  //                     Text(
  //                       "Edit Menu",
  //                       style: TextStyle(
  //                         color: Colors.black,
  //                         fontWeight: FontWeight.bold,
  //                       ),
  //                     ),
  //                     IconButton(
  //                       onPressed: () {
  //                         Get.back();
  //                       },
  //                       icon: Icon(
  //                         Icons.arrow_back,
  //                         size: 30,
  //                         color: Colors.orange,
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ],
  //             ),
  //           ),
  //         )),
  //   );
  // }
}
