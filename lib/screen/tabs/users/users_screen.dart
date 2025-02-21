import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timesheet/controller/user_controller.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User List",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      resizeToAvoidBottomInset: false,
      body: GetBuilder<UserController>(
        initState: (state) {
          Get.find<UserController>().getListUsersPage();
        },
        builder: (controller) {
          if (controller.loading) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.blueAccent),
            );
          }

          return Column(
            children: [
              Container(
                  padding: const EdgeInsets.all(10),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Search...",
                      prefixIcon:
                          const Icon(Icons.search, size: 18), // Nhỏ icon
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 6,
                          horizontal: 10), // Giảm padding bên trong
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  )),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  itemCount: controller.usersPage.length,
                  itemBuilder: (context, index) {
                    final user = controller.usersPage[index];

                    return Card(
                      elevation: 3,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 25,
                          backgroundImage: user.image != null
                              ? NetworkImage(user.getLinkImageUrl(
                                  user.image!)) // Hiển thị ảnh từ URL
                              : null,
                          child: user.image == null
                              ? Icon(Icons.person, size: 30)
                              : null,
                        ),
                        title: Text(
                          user.displayName ?? "No Name",
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        subtitle: Text(
                          user.email ?? "No Email",
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        trailing: Icon(
                          user.active! ? Icons.check_circle : Icons.cancel,
                          color: user.active! ? Colors.green : Colors.red,
                        ),
                      ),
                    );
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: controller.currentPage == 1
                          ? () {}
                          : () {
                              controller.currentPage -= 1;
                              controller.getListUsersPage();
                            },
                      child: Container(
                          width: 60,
                          child: const Text(
                            "Previous",
                            textAlign: TextAlign.center,
                          )),
                    ),
                    Text("Page ${controller.currentPage}",
                        style: const TextStyle(fontSize: 16)),
                    ElevatedButton(
                      onPressed: () {
                        controller.currentPage += 1;
                        controller.getListUsersPage();
                      },
                      child: Container(
                          width: 60,
                          child: const Text(
                            "Next",
                            textAlign: TextAlign.center,
                          )),
                    ),
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
