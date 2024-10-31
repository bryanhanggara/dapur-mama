import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/settings_controller.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Notifikasi'),
          centerTitle: true,
        ),
        body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(
            height: 20,
          ),
          const Text("Notifications").paddingSymmetric(horizontal: 10),
          SizedBox(
            height: 20,
          ),
          Obx(
            () => Card(
              child: ListTile(
                title: const Text("Pengingat Sarapan"),
                leading: const Icon(Icons.wb_sunny),
                trailing: Switch(
                  value: controller.sarapanToggle.value,
                  onChanged: (value) {
                    controller.toggleSarapan();
                  },
                ),
              ),
            ),
          ),
          Obx(
            () => Card(
              child: ListTile(
                title: const Text("Pengingat Makan Siang"),
                leading: const Icon(Icons.lunch_dining),
                trailing: Switch(
                  value: controller.siangToggle.value,
                  onChanged: (value) async {
                    await controller.toggleSiang();
                  },
                ),
              ),
            ),
          ),
          Obx(
            () => Card(
              child: ListTile(
                title: const Text("Pengingat Makan Malam"),
                leading: const Icon(Icons.dinner_dining),
                trailing: Switch(
                  value: controller.malamToggle.value,
                  onChanged: (value) {
                    controller.toggleMalam();
                  },
                ),
              ),
            ),
          ),
        ]));
  }
}
