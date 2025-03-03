import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timesheet/controller/user_controller.dart';
import 'package:timesheet/data/model/body/users/user.dart';
import 'package:timesheet/screen/tabs/setting/edit_profile_screen.dart';
import 'package:timesheet/screen/tabs/users/user_detail_screen.dart';

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
    if (results.isEmpty) {
      setState(() => filteredUsers = []);
    } else {
      setState(() => filteredUsers = results);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("user_list".tr,
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black)),
        centerTitle: true,
        backgroundColor: Theme.of(context).secondaryHeaderColor,
      ),
      resizeToAvoidBottomInset: false,
      body: GetBuilder<UserController>(
        builder: (controller) {
          final List<User> displayUsers =
              filteredUsers.isNotEmpty ? filteredUsers : controller.usersPage;
          return Column(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: "search...".tr,
                    prefixIcon: const Icon(
                      Icons.search,
                      size: 18,
                      color: Colors.grey,
                    ),
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
                  ? Expanded(
                      child: const Center(
                        child:
                            CircularProgressIndicator(color: Colors.blueAccent),
                      ),
                    )
                  : Expanded(
                      child: displayUsers.isEmpty
                          ? Center(child: Text("no_users_found".tr))
                          : ListView.builder(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              itemCount: displayUsers.length,
                              itemBuilder: (context, index) {
                                final user = displayUsers[index];
                                return Card(
                                  elevation: 3,
                                  color: Colors.white,
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: ListTile(
                                    onTap: controller.isAdmin
                                        ? () => _adminEditUser(user)
                                        : () {},
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
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black),
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
                                          ? Theme.of(context)
                                              .secondaryHeaderColor
                                          : Colors.red,
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
              if (filteredUsers.isEmpty)
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).disabledColor,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        spreadRadius: 2,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildPaginationButton(
                        context: context,
                        text: "Previous",
                        onPressed: controller.currentPage == 1
                            ? null
                            : () {
                                controller.currentPage -= 1;
                                controller.getListUsersPage();
                              },
                        isDisabled: controller.currentPage == 1,
                      ),
                      Text(
                        "Page ${controller.currentPage}",
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black54),
                      ),
                      _buildPaginationButton(
                        context: context,
                        text: "Next",
                        onPressed: controller.isLastPage
                            ? null
                            : () {
                                controller.currentPage += 1;
                                controller.getListUsersPage();
                              },
                        isDisabled: controller.isLastPage,
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

  Widget _buildPaginationButton({
    required BuildContext context,
    required String text,
    required VoidCallback? onPressed,
    required bool isDisabled,
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: isDisabled
            ? Colors.grey[300]
            : Theme.of(context).secondaryHeaderColor,
        foregroundColor: isDisabled ? Colors.black38 : Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      onPressed: onPressed,
      child: Text(text,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
    );
  }

  void _adminEditUser(User user) {
    Get.to(() => UserDetailScreen(user: user));
    // Get.to(() => EditProfileScreen(
    //       user: user,
    //     ));
  }
}
