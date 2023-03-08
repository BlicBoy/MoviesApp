import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:movies/main.dart';
import 'package:movies/models/movies.dart';
import 'package:movies/models/responseId.dart';
import 'package:movies/models/session.dart';
import 'models/api.dart';
import 'models/request_token.dart';
import 'models/login.dart';

class ProfileUser extends StatefulWidget {
  late bool logged;
  final Function() logout;
  ProfileUser({super.key, required this.logout(), required this.logged});

  @override
  State<ProfileUser> createState() => _ProfileUserState();
}

class _ProfileUserState extends State<ProfileUser> {
  late Box<DataLogin> loginBox;
  late Box<ResponseId> responseIdBox;
  final nameControler = TextEditingController();
  final passwordControler = TextEditingController();
  bool haslogin = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    loginBox = Hive.box<DataLogin>("session");
    widget.logged = loginBox.isNotEmpty;
    if (widget.logged) {
      session = loginBox.values.first;
    }

    responseIdBox = Hive.box<ResponseId>("sessionId");
    if (responseIdBox.isNotEmpty) {
      responseID = responseIdBox.values.first;
    }
  }

  DataLogin? session;
  ResponseId? responseID;

  Widget buildUserName() => TextField(
        controller: nameControler,
        decoration: InputDecoration(
            hintText: 'username',
            labelText: 'Username',
            prefixIcon: const Icon(Icons.person),
            suffixIcon: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => nameControler.clear(),
            )),
      );

  Widget buildPassword() => TextField(
        controller: passwordControler,
        obscureText: true,
        decoration: InputDecoration(
            hintText: 'password',
            labelText: 'Password',
            prefixIcon: const Icon(Icons.lock),
            suffixIcon: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => passwordControler.clear(),
            )),
      );

  Widget profile() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(
              height: 25,
            ),
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: NetworkImage(
                      '${profileAvatarURL}${session?.photoUserLogged}'),
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Text(session?.nameUserLogged ?? "",
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    height: 1.5,
                    letterSpacing: 0)),
            const SizedBox(
              height: 5,
            ),
            Text(session?.usernameLogged ?? "",
                style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                    height: 1.5,
                    letterSpacing: 0)),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton(
                onPressed: () async {
                  debugPrint("aqui");
                  await widget.logout();
                  widget.logged = false;
                  setState(() {});
                },
                child: const Text("Logout")),
          ],
        ),
      ),
    );
  }

  Widget formLogin() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: Image.network(
            'https://png.pngtree.com/template/20190629/ourmid/pngtree-home-movie-logo-simple-line-logo-template-vector-illustration-image_223617.jpg',
            height: 130,
            width: 130,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: buildUserName(),
        ),
        Padding(padding: const EdgeInsets.all(10), child: buildPassword()),
        ElevatedButton(
            onPressed: () {
              requestTokenToLogin();
            },
            child: const Text(
              'Login',
              style: TextStyle(fontSize: 20),
            ))
      ],
    );
  }

  Future<void> requestTokenToLogin() async {
    try {
      final response =
          await http.get(Uri.parse(requestTokenLogin + apiParam + apiKey));
      if (response.statusCode == 200) {
        final dynamic result = json.decode(response.body);
        RequestToken requestToken = RequestToken.fromJson(result);
        makeLogin(requestToken.request_token.toString());
        //debugPrint(requestToken.request_token);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> makeLogin(String token) async {
    try {
      SessionData data = SessionData(
          username: nameControler.text,
          password: passwordControler.text,
          tokenAcess: token);
      final response = await http.post(
          Uri.parse('${authentication}token$loginValidate$apiParam$apiKey'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8'
          },
          body: sessionDataLogin(data));

      debugPrint(sessionDataLogin(data));

      if (response.statusCode == 200) {
        await sessionId(token);
        debugPrint("Logged");
        nameControler.clear();
        passwordControler.clear();
      } else if (response.statusCode == 404) {
        debugPrint(response.statusCode.toString());
      } else if (response.statusCode == 401) {
        debugPrint(response.statusCode.toString());
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> sessionId(String token) async {
    try {
      final resquest = jsonEncode({"request_token": token});

      final response = await http.post(Uri.parse(sessionID + apiParam + apiKey),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8'
          },
          body: resquest);

      if (response.statusCode == 200) {
        final dynamic result = json.decode(response.body);
        ResponseId responseId = ResponseId.fromJson(result);

        //debugPrint(responseId.sessionId.toString());
        responseIdBox.put(responseId.sessionId, responseId);
        responseID = responseIdBox.values.first;
        completeLogin(responseId.sessionId.toString());
      } else {
        debugPrint("Error");
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> completeLogin(String sessionIdVar) async {
    try {
      final response = await http.get(Uri.parse(
          profileInfoURL + apiParam + apiKey + sessionParam + sessionIdVar));
      if (response.statusCode == 200) {
        final dynamic result = json.decode(response.body);
        DataLogin data = DataLogin.fromJson(result);
        loginBox.put(data.idUserLogged, data);
        session = loginBox.values.first;
        widget.logged = true;
        setState(() {});
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return !widget.logged ? formLogin() : profile();
  }
}
