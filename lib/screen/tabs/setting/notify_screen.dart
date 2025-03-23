import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timesheet/controller/notify_controller.dart';
import 'package:timesheet/data/model/body/notify.dart';
import 'package:timesheet/screen/tabs/setting/widget/notify_item.dart';

class NotifyScreen extends StatelessWidget {
  const NotifyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("notification".tr,
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Theme.of(context).secondaryHeaderColor,
        centerTitle: true,
      ),
      body: GetBuilder<NotifyController>(
        initState: (state) => Get.find<NotifyController>().getNotify(),
        builder: (controller) {
          if (controller.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.listNotifys.isEmpty) {
            return Center(
                child: Text("no_notifications".tr,
                    style: TextStyle(fontSize: 16)));
          }

          return RefreshIndicator(
            onRefresh: () => Get.find<NotifyController>().getNotify(),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: controller.listNotifys.length,
              itemBuilder: (context, index) {
                Notify item = controller.listNotifys[index];

                return NotifyItem(
                  item: item,
                );
              },
            ),
          );
        },
      ),
    );
  }
}
