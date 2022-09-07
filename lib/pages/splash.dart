// not just splash , will ask use for their name here

// ignore_for_file: prefer_const_constructors

import 'package:expense_tracker/color.dart';
import 'package:expense_tracker/controllers/db_helper.dart';
import 'package:expense_tracker/pages/add_name.dart';
import 'package:expense_tracker/pages/auth.dart';
import 'package:expense_tracker/pages/homepage.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  //
  DbHelper dbHelper = DbHelper();

  @override
  void initState() {
    super.initState();
    getName();
  }

  Future getName() async {
    String? name = await dbHelper.getName();
    name == null;
    if (name != null) {
      bool? auth = await dbHelper.getLocalAuth();
      if (auth) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => FingerPrintAuth(),
            // builder: (context) => AddName(),
          ),
        );
      } else {
        Future.delayed(Duration(seconds: 3), () {
          return Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => HomePage(),
            ),
          );
        });
      }
    } else {
      Future.delayed(Duration(seconds: 3), () {
        return Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => AddName(),
          ),
        );
      });
    }
  }

  //
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0.0,
      ),
      //
      backgroundColor: COLORS().backgroundColor,
      //
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white70,
            borderRadius: BorderRadius.circular(
              12.0,
            ),
          ),
          padding: EdgeInsets.all(
            16.0,
          ),
          // child: Image.asset(
          //   "assets/expense.png",
          //   width: 150.0,
          //   height: 150.0,
          // ),
          child: LottieBuilder.asset(
            "assets/lottie/wallet.json",
            width: 150,
            height: 150,
          ),
        ),
      ),
    );
  }
}
