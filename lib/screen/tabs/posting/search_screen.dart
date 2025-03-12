import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timesheet/controller/user_controller.dart';
import 'package:timesheet/data/model/body/users/user.dart';
import 'package:timesheet/screen/tabs/posting/personal_page_screen.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final UserController userController = Get.find<UserController>();
  List<User> searchResults = [];
  @override
  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    if (userController.listUsers.isEmpty) {
      await userController.getListUsersPage();
      print("Số lượng user sau khi fetch: ${userController.listUsers.length}");
      setState(() {}); // Cập nhật lại UI sau khi có dữ liệu
    }
  }

  void _searchUsers(String query) {
    if (query.isEmpty) {
      setState(() => searchResults = []);
      return;
    }

    List<User> results = userController.listUsers
        .where((user) =>
            user.displayName?.toLowerCase().contains(query.toLowerCase()) ??
            false)
        .take(5) // Giới hạn kết quả tối đa 5
        .toList();

    setState(() => searchResults = results);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: TextField(
          controller: _searchController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: "search_for_users...".tr,
            border: InputBorder.none,
          ),
          onChanged: _searchUsers,
        ),
      ),
      body: searchResults.isEmpty
          ? Center(child: Text("enter_keywords_to_search".tr))
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 10),
              itemCount: searchResults.length,
              itemBuilder: (context, index) {
                User user = searchResults[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: user.hasPhoto!
                        ? NetworkImage(user.getLinkImageUrl(user.image!))
                        : null,
                    child: user.hasPhoto! ? null : Icon(Icons.person),
                  ),
                  title: Text(user.displayName ?? "no_name".tr),
                  onTap: () {
                    Get.to(() => PersonalPageScreen(
                          userId: user.id!,
                          displayName: user.displayName!,
                        ));
                  },
                );
              },
            ),
    );
  }
}
