import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timesheet/controller/user_controller.dart';
import 'package:timesheet/data/model/body/users/user.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  _UsersScreenState createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<User> filteredUsers = [];

  @override
  void initState() {
    super.initState();
    Get.find<UserController>().restartListUser();
  }

  void _searchUsers(String query) {
    final UserController userController = Get.find<UserController>();
    if (query.isEmpty) {
      setState(() => filteredUsers = []);
      return;
    }

    List<User> results = userController.listUsers
        .where((user) =>
            user.displayName?.toLowerCase().contains(query.toLowerCase()) ??
            false)
        .take(10)
        .toList();

    setState(() => filteredUsers = results);
  }

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
        builder: (controller) {
          final List<User> displayUsers =
              filteredUsers.isNotEmpty ? filteredUsers : controller.usersPage;

          return Column(
            children: [
              // Ô tìm kiếm
              Container(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: "Search...",
                    prefixIcon: const Icon(Icons.search, size: 18),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  onChanged: _searchUsers,
                ),
              ),

              controller.loading == true
                  ? const Center(
                      child:
                          CircularProgressIndicator(color: Colors.blueAccent),
                    )
                  : Expanded(
                      child: displayUsers.isEmpty
                          ? const Center(child: Text("No users found"))
                          : ListView.builder(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              itemCount: displayUsers.length,
                              itemBuilder: (context, index) {
                                final user = displayUsers[index];

                                return Card(
                                  elevation: 3,
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 8),
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
                                          ? const Icon(Icons.person, size: 30)
                                          : null,
                                    ),
                                    title: Text(
                                      user.displayName ?? "No Name",
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    subtitle: Text(
                                      user.email ?? "No Email",
                                      style: TextStyle(color: Colors.grey[600]),
                                    ),
                                    trailing: Icon(
                                      user.active!
                                          ? Icons.check_circle
                                          : Icons.cancel,
                                      color: user.active!
                                          ? Colors.green
                                          : Colors.red,
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),

              // Pagination Controls (ẩn nếu đang tìm kiếm)
              if (filteredUsers.isEmpty && controller.loading == false)
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: controller.currentPage == 1
                            ? null
                            : () {
                                controller.currentPage -= 1;
                                controller.getListUsersPage();
                              },
                        child: const Text("Previous"),
                      ),
                      Text("Page ${controller.currentPage}",
                          style: const TextStyle(fontSize: 16)),
                      ElevatedButton(
                        onPressed: () {
                          controller.currentPage += 1;
                          controller.getListUsersPage();
                        },
                        child: const Text("Next"),
                      ),
                    ],
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
