import 'dart:io';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myapp/app/components/snackbar.dart';

import '../controllers/add_food_controller.dart';

class AddFoodView extends GetView<AddFoodController> {
  const AddFoodView({super.key});
  @override
  Widget build(BuildContext context) {
    final Snackbar snackbar = Snackbar();
    return Scaffold(
      appBar: AppBar(
        title: const Text('NEW RECIPE'),
        centerTitle: true,
      ),
      body: Obx(
        () => SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                height: 70,
                alignment: Alignment.centerLeft,
                width: double.infinity,
                decoration: BoxDecoration(color: Colors.red),
                child: Text(
                  "SuperCool you are creating a new receipe! \n"
                  "Let's get started",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Nama Makanan",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    TextField(
                      controller: controller.namaController,
                      decoration: InputDecoration(
                        hintText: "Nama Makanan",
                        hintStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      "Gambar Makanan",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        controller.image.value.path != ""
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.file(
                                  File(controller.image.value.path),
                                  height: 200,
                                  width: 200,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : GestureDetector(
                                onTap: () async {
                                  await controller.getImage(true);
                                },
                                child: Container(
                                  height: 200,
                                  width: 200,
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Center(
                                    child: Text("Tambah Gambar"),
                                  ),
                                ),
                              ),
                        Obx(
                          () => Center(
                            child: controller.image.value.path != ""
                                ? IconButton(
                                    onPressed: () async {
                                      controller.image.value = XFile("");
                                    },
                                    icon: Icon(
                                      Icons.delete,
                                    ),
                                  )
                                : SizedBox(),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      "Jenis",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: double.infinity,
                      height: 50,
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: DropdownButton(
                          alignment: Alignment.center,
                          isExpanded: true,
                          underline: const SizedBox(),
                          iconSize: 30,
                          dropdownColor: Colors.red,
                          value: controller.selectedJenis.value,
                          icon: const Icon(Icons.arrow_drop_down,
                              color: Colors.white),
                          items: controller.selectJenis.map((String items) {
                            return DropdownMenuItem(
                              value: items,
                              child: Text(items,
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.white)),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            controller.selectedJenis.value =
                                newValue.toString();
                          }),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      "Estimasi Waktu Memasak",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    TextField(
                      controller: controller.waktupembuatanController,
                      decoration: InputDecoration(
                        hintText: "Waktu Memasak (menit)",
                        hintStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      "Deskripsi",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    TextField(
                      controller: controller.deskripsiController,
                      decoration: InputDecoration(
                        hintText: "Deskripsi",
                        hintStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                        ),
                      ),
                      maxLines: 3,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      "Resep dan Cara Membuat",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    TextField(
                      controller: controller.resepController,
                      decoration: InputDecoration(
                        hintText: "Resep dan cara membuat",
                        hintStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                        ),
                      ),
                      maxLines: 10,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (controller.namaController.text.isEmpty ||
                              controller
                                  .waktupembuatanController.text.isEmpty ||
                              controller.deskripsiController.text.isEmpty ||
                              controller.selectedJenis.value.isEmpty ||
                              controller.image.value.path.isEmpty) {
                            snackbar.snackbarAuth(
                                "Eror", "Lengkapi Form Terlebih dahulu");
                          } else {
                            await controller.saveImages(
                                File(controller.image.value.path),
                                controller.namaController.text,
                                int.parse(
                                    controller.waktupembuatanController.text),
                                controller.deskripsiController.text,
                                controller.selectedJenis.value,
                                controller.resepController.text);
                            Get.back();
                            snackbar.snackbarAuth(
                                "Berhasil", "Berhasil ditambahkan");
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red),
                        child: Text(
                          "Tambah",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
