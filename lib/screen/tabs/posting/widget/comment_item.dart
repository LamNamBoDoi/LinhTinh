import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timesheet/data/model/body/post/comment.dart';
import 'package:intl/intl.dart';

class CommentItem extends StatelessWidget {
  const CommentItem({super.key, required this.comment});
  final Comment comment;
  @override
  Widget build(BuildContext context) {
    if (comment == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            child:
                comment.user!.hasPhoto! ? null : Icon(Icons.person, size: 20),
            radius: 20,
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        comment.user!.displayName!,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      const SizedBox(height: 3),
                      Text(comment.content,
                          style: const TextStyle(fontSize: 14)),
                    ],
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Text(
                      DateFormat('dd/MM/yyyy HH:mm').format(
                        DateTime.fromMillisecondsSinceEpoch(comment.date),
                      ),
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: () {},
                      child: Text("like".tr,
                          style: TextStyle(color: Colors.blue, fontSize: 12)),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: () {},
                      child: Text("reply".tr,
                          style: TextStyle(color: Colors.blue, fontSize: 12)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
