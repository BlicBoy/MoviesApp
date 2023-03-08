import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

part 'login.g.dart';

@HiveType(typeId: 1)
class DataLogin {
  @HiveField(0)
  int? idUserLogged;
  @HiveField(1)
  String? usernameLogged;
  @HiveField(2)
  String? nameUserLogged;
  @HiveField(3)
  String? photoUserLogged;

  DataLogin(
      {this.idUserLogged,
      this.usernameLogged,
      this.nameUserLogged,
      this.photoUserLogged});

  factory DataLogin.fromJson(Map<String, dynamic> json) => DataLogin(
      idUserLogged: json['id'] ?? "",
      usernameLogged: json['username'] ?? "",
      nameUserLogged: json['name'] ?? "", 
      photoUserLogged: json['avatar']['tmdb']['avatar_path'] ?? "");


}
