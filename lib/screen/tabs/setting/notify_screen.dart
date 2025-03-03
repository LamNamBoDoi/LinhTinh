import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timesheet/controller/notify_controller.dart';
import 'package:timesheet/data/model/body/notify.dart';
import 'package:intl/intl.dart';

class NotifyScreen extends StatelessWidget {
  const NotifyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Thông báo",
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
            return const Center(
                child: Text("Không có thông báo nào.",
                    style: TextStyle(fontSize: 16)));
          }

          return RefreshIndicator(
            onRefresh: _onRefresh,
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: controller.listNotifys.length,
              itemBuilder: (context, index) {
                Notify item = controller.listNotifys[index];

                return _buildNotificationCard(item);
              },
            ),
          );
        },
      ),
    );
  }

  /// Widget tạo card thông báo đẹp hơn
  Widget _buildNotificationCard(Notify item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        elevation: 4,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            // TODO: Xử lý khi nhấn vào thông báo (ví dụ: điều hướng)
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
            ),
            child: ListTile(
              leading: _getNotificationIcon(item.type ?? ""),
              title: Text(
                item.title ?? "Không có tiêu đề",
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.black),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text(
                    item.body ?? "Không có nội dung",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.black45),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _formatDate(item.date),
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
              trailing: const Icon(Icons.arrow_forward_ios,
                  size: 16, color: Colors.grey),
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(int? timestamp) {
    if (timestamp == null) return "Không xác định";
    DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return DateFormat('dd/MM/yyyy').format(date);
  }

  Widget _getNotificationIcon(String type) {
    IconData iconData;
    Color iconColor;

    switch (type) {
      case "N01":
        iconData = Icons.notifications_active;
        iconColor = Colors.blue;
        break;
      case "N02":
        iconData = Icons.warning_amber;
        iconColor = Colors.orange;
        break;
      case "N03":
        iconData = Icons.error;
        iconColor = Colors.red;
        break;
      default:
        iconData = Icons.notifications;
        iconColor = Colors.grey;
    }

    return CircleAvatar(
      backgroundColor: iconColor.withOpacity(0.2),
      child: Icon(iconData, color: iconColor),
    );
  }

  Future<void> _onRefresh() {
    return Get.find<NotifyController>().getNotify();
  }
}
