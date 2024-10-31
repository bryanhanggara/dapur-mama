import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:myapp/app/utils/notification_api.dart';

class SettingsController extends GetxController {
  final sarapanToggle = false.obs;
  final siangToggle = false.obs;
  final malamToggle = false.obs;

  GetStorage box = GetStorage();

  @override
  void onInit() async {
    super.onInit();
    NotificationApi.init();

    // Baca status toggle dari GetStorage dan jadwalkan notifikasi jika statusnya true
    if (await box.read('sarapan') != null) {
      sarapanToggle.value = box.read('sarapan');
      if (sarapanToggle.value) {
        NotificationApi.scheduledNotification(
          id: 1,
          title: "Jangan Lupa Sarapan",
          body: "Yuk cek resep di katalog!",
          payload: "sarapan",
          scheduledDate: const TimeOfDay(hour: 7, minute: 0),
        );
      }
    }

    if (await box.read('siang') != null) {
      siangToggle.value = box.read('siang');
      if (siangToggle.value) {
        NotificationApi.scheduledNotification(
          id: 2,
          title: "Lets have lunch!",
          body: "Lihat resep makanan siang hari ini",
          payload: "siang",
          scheduledDate: const TimeOfDay(hour: 12, minute: 0),
        );
      }
    }

    if (await box.read('malam') != null) {
      malamToggle.value = box.read('malam');
      if (malamToggle.value) {
        NotificationApi.scheduledNotification(
          id: 3,
          title: "Yuk Dinner",
          body: "Jangan lupa makan malam ya, nanti tidurnya akan lebih nyenyak",
          payload: "malam",
          scheduledDate: const TimeOfDay(hour: 16, minute: 0),
        );
      }
    }
  }

  void toggleSarapan() async {
    sarapanToggle.toggle();
    box.write("sarapan", sarapanToggle.value);
    if (sarapanToggle.value) {
      NotificationApi.scheduledNotification(
        id: 1,
        title: "Jangan Lupa Sarapan",
        body: "Yuk cek resep di katalog!",
        payload: "sarapan",
        scheduledDate: const TimeOfDay(hour: 7, minute: 0),
      ).then((value) {
        Get.snackbar("Berhasil", "Pengingat sarapan berhasil diaktifkan",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white);
      });
    } else {
      NotificationApi.cancelNotification(1).then((value) => Get.snackbar(
          "Berhasil", "Pengingat sarapan berhasil dinonaktifkan",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white));
    }
  }

  Future<void> toggleSiang() async {
    siangToggle.toggle();
    box.write("siang", siangToggle.value);
    if (siangToggle.value) {
      await NotificationApi.scheduledNotification(
        id: 2,
        title: "Lets have lunch!",
        body: "Lihat resep makanan siang hari ini",
        payload: "siang",
        scheduledDate: const TimeOfDay(hour: 12, minute: 0),
      ).then((value) {
        Get.snackbar("Berhasil", "Pengingat makan siang berhasil diaktifkan",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white);
      });
    } else {
      NotificationApi.cancelNotification(2).then((value) {
        Get.snackbar("Berhasil", "Pengingat makan siang berhasil dinonaktifkan",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white);
      });
    }
  }

  void toggleMalam() {
    malamToggle.toggle();
    box.write("malam", malamToggle.value);
    if (malamToggle.value) {
      NotificationApi.scheduledNotification(
        id: 3,
        title: "Yuk Dinner",
        body: "Jangan lupa makan malam ya, nanti tidurnya akan lebih nyenyak",
        payload: "malam",
        scheduledDate: const TimeOfDay(hour: 16, minute: 35),
      ).then((value) {
        Get.snackbar("Berhasil", "Pengingat makan malam berhasil diaktifkan",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white);
      });
    } else {
      NotificationApi.cancelNotification(3).then((value) {
        Get.snackbar("Berhasil", "Pengingat makan malam berhasil dinonaktifkan",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white);
      });
    }
  }
}
