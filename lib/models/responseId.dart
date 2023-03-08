import 'dart:convert';

import 'package:hive/hive.dart';



part 'responseId.g.dart';

@HiveType(typeId: 2)
class ResponseId {

  @HiveField(0)
  String sessionId;
  @HiveField(1)
  bool success;

  ResponseId({required this.sessionId, required this.success});

  factory ResponseId.fromJson(Map<String, dynamic> json) => ResponseId(
        success: json["success"],
        sessionId: json["session_id"],
      );
}