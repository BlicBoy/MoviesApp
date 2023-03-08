import 'dart:convert';

import 'package:hive/hive.dart';



String sessionDataLogin(SessionData data) => json.encode(data.toJson());

class SessionData {
  late final String? username;
  late final String? password;
  late final String? tokenAcess;

  SessionData({this.username, this.password, this.tokenAcess});

  Map<String, dynamic> toJson() => {
        "username": username,
        "password": password,
        "request_token": tokenAcess,
      };
}




