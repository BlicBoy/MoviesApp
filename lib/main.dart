import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:hive/hive.dart';


import 'package:movies/models/movies.dart';
import 'package:movies/models/responseId.dart';

import 'package:movies/splash_screen.dart';
import 'package:movies/themes/Themes.dart';

import 'package:path_provider/path_provider.dart';


import 'models/login.dart';

const String movieBox = "movie";
const String sessionBox = "session";
const String sessionId = "sessionId";
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final document = await getApplicationDocumentsDirectory();
  Hive.init(document.path);

  Hive.registerAdapter(MoviesAdapter());
  await Hive.openBox<Movies>(movieBox);

  Hive.registerAdapter(DataLoginAdapter());
  await Hive.openBox<DataLogin>(sessionBox);

  Hive.registerAdapter(ResponseIdAdapter());
  await Hive.openBox<ResponseId>(sessionId);

  runApp(const App());
}


class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: Themes.light,
      darkTheme: Themes.dark,
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
