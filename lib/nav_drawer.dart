import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:movies/models/login.dart';
import 'package:movies/models/responseId.dart';
import 'package:http/http.dart' as http;
import 'package:movies/profile_page.dart';

import 'models/api.dart';

class NavDrawer extends StatefulWidget {
  final Function() update;
  final Function() logout;
  const NavDrawer({super.key, required this.update, required this.logout});

  @override
  State<NavDrawer> createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> {
  late Box<DataLogin> loginBox;
  late Box<ResponseId> responseIdBox;
  DataLogin? loginData;
  ResponseId? responseId;
  bool haslogin = false;

  @override
  void initState() {
    super.initState();
    responseIdBox = Hive.box("sessionId");
    if (responseIdBox.isNotEmpty) {
      responseId = responseIdBox.values.first;
    }

    loginBox = Hive.box("session");
    haslogin = loginBox.isNotEmpty;
    if (haslogin) {
      loginData = loginBox.values.first;
    }
  }

  Widget drawerLogged() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            // ignore: sort_child_properties_last
            child: Text(
              loginData?.usernameLogged ?? "",
              style: const TextStyle(color: Colors.white, fontSize: 25),
            ),
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fill,
                image: NetworkImage(
                    '${profileAvatarURL}${loginData?.photoUserLogged}'),
              ),
            ),
          ),
          ListTile(
            leading: Get.isDarkMode
                ? const Icon(Icons.nightlight_round_outlined)
                : const Icon(Icons.sunny),
            title: const Text('Tema'),
            onTap: () {
              if (Get.isDarkMode) {
                Get.changeThemeMode(ThemeMode.light);
              } else {
                Get.changeThemeMode(ThemeMode.dark);
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Logout'),
            onTap: () async {
              Navigator.of(context).pop();
              await widget.logout();
              await widget.update();
              
            },
          ),
        ],
      ),
    );
  }

  Widget drawernotLogged() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: NetworkImage(
                      'https://assets-global.website-files.com/6171adb6a942ed69f5e6b5ee/638dfe68d3dcc56e359db13d_1-phoenixes-nft-min.png'),
                ),
              ),
              child: Text(
                'Sem sessão',
                style: TextStyle(color: Colors.white, fontSize: 25),
              )),
          ListTile(
            leading: Get.isDarkMode
                ? const Icon(Icons.nightlight_round_outlined)
                : const Icon(Icons.sunny),
            title: const Text('Tema'),
            onTap: () {
              if (Get.isDarkMode) {
                Get.changeThemeMode(ThemeMode.light);
              } else {
                Get.changeThemeMode(ThemeMode.dark);
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return !haslogin ? drawernotLogged() : drawerLogged();
  }
}
