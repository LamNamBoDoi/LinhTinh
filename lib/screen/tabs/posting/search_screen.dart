import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timesheet/controller/post_controller.dart';
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
  bool isLoadingMore = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userController.restartListUser();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.5,
          leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () async {
                await Get.find<PostController>().resetListPost("");
                Get.back();
              }),
          title: TextField(
              controller: _searchController,
              style: TextStyle(color: Colors.black),
              autofocus: true,
              decoration: InputDecoration(
                hintText: "search_for_users...".tr,
                border: InputBorder.none,
              ),
              onChanged: (query) => userController.searchUsers(query)),
        ),
        body: GetBuilder<UserController>(builder: (controller) {
          final List<User> displayUsers = controller.listFilteredUser.isNotEmpty
              ? controller.listFilteredUser
              : [];
          return displayUsers.isEmpty
              ? Center(child: Text("enter_keywords_to_search".tr))
              : ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  itemCount: displayUsers.length,
                  itemBuilder: (context, index) {
                    User user = displayUsers[index];
                    return ListTile(
                        leading: CircleAvatar(
                          radius: 20,
                          backgroundImage: (user.image != "" &&
                                  user.image != null)
                              ? NetworkImage(user.getLinkImageUrl(user.image!))
                              : AssetImage("assets/image/avatarDefault.jpg")
                                  as ImageProvider,
                        ),
                        title: Text(user.displayName ?? "no_name".tr,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            )),
                        onTap: () => Get.to(() => PersonalPageScreen(
                              isMyPost: user.id == userController.currentUser.id
                                  ? true
                                  : false,
                              userId: user.id!,
                              displayName: user.displayName!,
                            )));
                  },
                );
        }));
  }
}
