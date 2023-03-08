import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:get/utils.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive/hive.dart';
import 'package:movies/follow_movies.dart';
import 'package:movies/nav_drawer.dart';

import 'package:movies/profile_page.dart';
import 'package:movies/themes/Themes.dart';
import 'package:movies/themes/apptheme.dart';
import 'bottom_bar.dart';
import 'models/api.dart';
import 'models/login.dart';
import 'models/responseId.dart';
import 'movies_list.dart';

import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;
  bool logged = false;
  late List screens = [
    const MoviesList(),
    const FollowMovies(),
    ProfileUser(
      logout: logout,
      logged: logged,
    )
  ];

  late Box<DataLogin> loginBox;
  late Box<ResponseId> responseIdBox;

  DataLogin? session;
  ResponseId? responseID;

  @override
  void initState() {
    super.initState();
    loginBox = Hive.box<DataLogin>("session");
    logged = loginBox.isNotEmpty;
    if (logged) {
      session = loginBox.values.first;
    }
  }

  void onClicked(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  Future<void> logout() async {
    try {
      responseIdBox = Hive.box<ResponseId>("sessionId");
      if (responseIdBox.isNotEmpty) {
        responseID = responseIdBox.values.first;
      }
      session = loginBox.values.first;

      final request = jsonEncode({"session_id": responseID?.sessionId});
      final response = await http.delete(
          Uri.parse(logoutURL + apiParam + apiKey),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8'
          },
          body: request);

      if (response.statusCode == 200) {
        logged = false;
        loginBox.delete(session?.idUserLogged);
        responseIdBox.delete(responseID?.sessionId);
        screens = [
          const MoviesList(),
          const FollowMovies(),
          ProfileUser(
            logout: logout,
            logged: logged,
          )
        ];
        setState(() {});
      } else {
        debugPrint("erro ${response.statusCode}");
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      drawer: NavDrawer(
          logout: logout,
          update: () {
            setState(() {
              debugPrint("Aqui");
            });
          }),
      appBar: AppBar(
        title: const Text('Movies'),
        actions: [],
      ),
      body: Center(child: screens.elementAt(selectedIndex)),
      bottomNavigationBar: BottomBar(
        selectedIndex: selectedIndex,
        onClicked: onClicked,
      ),
    );
  }
}
