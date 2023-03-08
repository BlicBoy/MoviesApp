import 'package:flutter/material.dart';

class Themes {
  static final light = ThemeData.light().copyWith(
    backgroundColor: Colors.white,
    buttonColor: Colors.cyan,
    bottomAppBarColor: Colors.cyan,
    buttonTheme: const ButtonThemeData(
        buttonColor: Colors.cyan, textTheme: ButtonTextTheme.primary),
  );
  static final dark = ThemeData.dark().copyWith(
    backgroundColor: Colors.black,
    buttonColor: Colors.deepPurple,
    bottomAppBarColor: Colors.deepPurple,
    buttonTheme: const ButtonThemeData(
      buttonColor: Colors.deepPurple,
      textTheme: ButtonTextTheme.primary,
    ),
  );
}
