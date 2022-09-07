// ignore_for_file: prefer_const_constructors

import 'package:expense_tracker/color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'pages/splash.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('money');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Expenses Tracker',
      theme: ThemeData(
        fontFamily: "customFont",
        primaryColor: COLORS().primaryColor,
        appBarTheme: AppBarTheme(
          backgroundColor: COLORS().primaryColor,
        ),
      ),
      color: Colors.redAccent,
      home: Splash(),
    );
  }
}
