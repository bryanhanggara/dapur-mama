import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class AddFoodController extends GetxController {
  final image = XFile("").obs;

  CollectionReference ref = FirebaseFirestore.instance.collection('Food');

  TextEditingController namaController = TextEditingController();
  TextEditingController waktupembuatanController = TextEditingController();
  TextEditingController deskripsiController = TextEditingController();
  TextEditingController resepController = TextEditingController();

  final selectJenis = ['All', 'Makanan', 'Minuman', 'Kuah'];

  final selectedJenis = "Makanan".obs;

  //method untuk get image dari galeri/kamera
  Future getImage(bool gallery) async {
    ImagePicker picker = ImagePicker();

    XFile? pickedFile;

    if (gallery) {
      pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
      );
    } else {
      pickedFile = await picker.pickImage(
        source: ImageSource.camera,
      );
    }

    if (pickedFile != null) {
      image.value = pickedFile;
    }
  }

  //method untuk upload ke firestore
  Future<String> uploadFile(File image) async {
    final storageReference = FirebaseStorage.instance.ref().child(
          'Menu/${image.path}',
        );
    await storageReference.putFile(image);
    String returnUrl = "";

    await storageReference.getDownloadURL().then(
      (fileURL) {
        returnUrl = fileURL;
      },
    );
    return returnUrl;
  }

  //method untuk save image dan gambar
  Future<void> saveImages(
    File images,
    String nama,
    int waktuPembuatan,
    String deskripsi,
    String jenis,
    String resep,
  ) async {
    Get.bottomSheet(
      Container(
        height: 80,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CircularProgressIndicator(),
            Text("Loading"),
          ],
        ),
      ),
    );
    //upload ke firestore dan simpan pada imageUrl
    String imageUrl = await uploadFile(images);
    final refDoc = ref.doc();

    //upload data resep ke firestore dan simpan url gabar yg sudah diupload
    final data = {
      "id": refDoc.id,
      "nama": nama,
      "deskripsi": deskripsi,
      "waktu_pembuatan": waktuPembuatan,
      "jenis": jenis,
      "resep": resep,
      "images": imageUrl
    };

    refDoc.set(data);
    Get.back();
  }
}
