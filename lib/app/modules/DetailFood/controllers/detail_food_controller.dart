import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myapp/app/data/Food.dart';

class DetailFoodController extends GetxController with StateMixin {
  CollectionReference ref = FirebaseFirestore.instance.collection('Food');
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;

  var selectedImage = Rx<XFile?>(null);

  void pickImage(XFile? image) {
    selectedImage.value = image;
  }

  var foodId = ''.obs;

  Future<DocumentSnapshot<Object?>> getFood(String docId) async {
    DocumentReference docRef =
        FirebaseFirestore.instance.collection('Food').doc(docId);
    return docRef.get();
  }

  Future<void> deleteMenu(String id) async {
    final refDoc = ref.doc(id);
    await refDoc.delete();
  }

  Future<void> getFoodId(String id) async {
    foodId.value = id;
  }

  Future<void> updateMenu(
    Food food,
    XFile? image,
    String nama,
    int waktuPembuatan,
    String deskripsi,
    String resep,
  ) async {
    try {
      if (image != null) {
        final ref = storage.ref().child('Menu/${image.path}');
        await ref.putFile(File(image.path));

        final imageUrl = await ref.getDownloadURL();
        food.images = imageUrl;
      }

      food = food.copyWith(
        nama: nama,
        waktuPembuatan: waktuPembuatan,
        deskripsi: deskripsi,
        resep: resep,
      );

      await firestore.collection('Food').doc(food.id).update(food.toJson());
    } catch (e) {
      print(e);
      Get.snackbar("Eror", "Gagal update");
    }
  }

  // Future<String> uploadFile(File image) async {
  //   final storageReferences =
  //       FirebaseStorage.instance.ref().child('Menu/${image.path}');

  //   await storageReferences.putFile(image);
  //   String returnUrl = "";

  //   await storageReferences.getDownloadURL().then(
  //     (fileUrl) {
  //       returnUrl = fileUrl;
  //     },
  //   );
  //   return returnUrl;
  // }

  // Future<void> updateImageWithUrl(
  //   String id,
  //   String nama,
  //   int waktuPembuatan,
  //   String deskripsi,
  //   String jenis,
  //   File images,
  //   String resep,
  // ) async {
  //   change(null, status: RxStatus.loading());
  //   String imageUrl = await uploadFile(images);
  //   final refDoc = ref.doc(id);

  //   final data = {
  //     "id": id,
  //     "nama": nama,
  //     "waktu_pembuatan": waktuPembuatan,
  //     "deskripsi": deskripsi,
  //     "jenis": jenis,
  //     "images": imageUrl,
  //     "resep": resep,
  //   };

  //   refDoc
  //       .set(data)
  //       .then((value) => change(null, status: RxStatus.success()))
  //       .onError((error, stackTrace) =>
  //           change(null, status: RxStatus.error(error.toString())));
  // }

  // Future<void> updateMenu(String id, String nama, int waktuPembuatan,
  //     String deskripsi, String jenis, String image, String resep) async {
  //   change(null, status: RxStatus.loading());
  //   final refDoc = ref.doc(id);
  //   final data = {
  //     "id": id,
  //     "nama": nama,
  //     "waktu_pembuatan": waktuPembuatan,
  //     "deskripsi": deskripsi,
  //     "jenis": jenis,
  //     "images": image,
  //     "resep": resep,
  //   };
  //   refDoc
  //       .set(data)
  //       .then((value) => change(null, status: RxStatus.success()))
  //       .onError((error, stackTrace) =>
  //           change(null, status: RxStatus.error(error.toString())));
  // }
}
