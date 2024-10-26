import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/app/data/Food.dart';

class HomeController extends GetxController {
  CollectionReference ref = FirebaseFirestore.instance.collection("Food");

  final buttonText = ["All", "Makanan", "Minuman", "Kuah"];

  final iconButton = [
    'assets/images/makanan_icon.jpg',
    'assets/images/makanan_icon.jpg',
    'assets/images/makanan_icon.jpg',
    'assets/images/makanan_icon.jpg',
  ];

  final selecetedValueIndex = 0.obs;

  Stream<List<Food>> readRecipe(String jenis) {
    if (jenis != "All") {
      return FirebaseFirestore.instance
          .collection("Food")
          .where('jenis', isEqualTo: jenis)
          .snapshots()
          .map((snapshot) =>
              snapshot.docs.map((doc) => Food.fromJson(doc.data())).toList());
    } else {
      return FirebaseFirestore.instance.collection('Food').snapshots().map(
          (snapshot) =>
              snapshot.docs.map((doc) => Food.fromJson(doc.data())).toList());
    }
  }

  Stream<List<Food>> searchRecipe(String search) {
    return FirebaseFirestore.instance
        .collection('Food')
        .where('nama', isGreaterThanOrEqualTo: search)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Food.fromJson(doc.data())).toList());
  }

  Color getColor(String jenis) {
  switch (jenis) {
    case 'Makanan':
      return Colors.green; 
    case 'Minuman':
      return Colors.blue; 
    case 'Kuah':
      return Colors.orange; 
    default:
      return Colors.grey;
  }
}

}
