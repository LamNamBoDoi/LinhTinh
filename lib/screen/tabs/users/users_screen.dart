import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timesheet/controller/user_controller.dart';
import 'package:timesheet/data/model/body/users/user.dart';
import 'package:timesheet/screen/tabs/users/widget/user_item.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  _UsersScreenState createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late UserController userController;
  bool isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    userController = Get.find<UserController>();
    userController.restartListUser();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !isLoadingMore) {
      _loadMoreUsers();
    }
  }

  Future<void> _loadMoreUsers() async {
    setState(() => isLoadingMore = true);
    userController.currentPage += 1;
    await userController.getListUsersPage(isUpdate: false);
    setState(() => isLoadingMore = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("user_list".tr,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Theme.of(context).secondaryHeaderColor,
      ),
      resizeToAvoidBottomInset: false,
      body: GetBuilder<UserController>(
        builder: (controller) {
          final List<User> displayUsers = controller.listFilteredUser.isNotEmpty
              ? controller.listFilteredUser
              : controller.usersPageCurrent;
          return Stack(
            children: [
              Column(
                children: [
                  _buildSearchBar(),
                  Expanded(
                    child: displayUsers.isEmpty
                        ? SizedBox()
                        : ListView.builder(
                            physics: const ClampingScrollPhysics(),
                            controller: _scrollController,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            itemCount: displayUsers.length,
                            itemBuilder: (context, index) => UserItem(
                              user: displayUsers[index],
                              userController: controller,
                            ),
                          ),
                  ),
                ],
              ),
              if (controller.loading)
                const Center(
                    child: CircularProgressIndicator(color: Colors.blueAccent)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: TextField(
        style: TextStyle(color: Colors.black),
        controller: _searchController,
        decoration: InputDecoration(
          hintText: "search...".tr,
          prefixIcon: const Icon(Icons.search, size: 18, color: Colors.grey),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
          filled: true,
          fillColor: Colors.white,
        ),
        onChanged: (query) => Get.find<UserController>().searchUsers(query),
      ),
    );
  }
}
