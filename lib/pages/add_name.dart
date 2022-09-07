//  will ask use for their name here

// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'package:expense_tracker/controllers/db_helper.dart';
import 'package:expense_tracker/pages/homepage.dart';
import 'package:expense_tracker/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';

class AddName extends StatefulWidget {
  const AddName({Key? key}) : super(key: key);

  @override
  _AddNameState createState() => _AddNameState();
}

class _AddNameState extends State<AddName> {
  //
  DbHelper dbHelper = DbHelper();

  String name = "";

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
      body: SingleChildScrollView(
        reverse: true,
        child: Padding(
          padding: EdgeInsets.all(
            12.0,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 100),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white70,
                  borderRadius: BorderRadius.circular(
                    20.0,
                  ),
                ),
                padding: EdgeInsets.all(
                  16.0,
                ),
                child: LottieBuilder.asset("assets/lottie/wallet.json",width: 120,height: 120,),
              ),
              //
              SizedBox(
                height: 20.0,
              ),
              //
              Text(
                "Please Enter Your Nickname !",
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.w900,
                ),
              ),
              //
              SizedBox(
                height: 20.0,
              ),
              //
              Container(
                decoration: BoxDecoration(
                  color: Colors.white70,
                  borderRadius: BorderRadius.circular(
                    12.0,
                  ),
                ),
                padding: EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 16.0,
                ),
                child: TextField(
                  cursorColor: COLORS().primaryColor,
                  cursorWidth: 6,
                  decoration: InputDecoration(
                    hintText: " Nick Name",
                    border: InputBorder.none,
                  ),
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold
                  ),
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(9),
                  ],
                  // maxLength: 12,
                  onChanged: (val) {
                    name = val;
                  },
                ),
              ),
              //
              SizedBox(
                height: 20.0,
              ),
              //
              SizedBox(
                height: 70,
                child: ElevatedButton(
                  onPressed: () async {
                    if (name.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          action: SnackBarAction(
                            label: "OK",
                            onPressed: () {
                              ScaffoldMessenger.of(context).hideCurrentSnackBar();
                            },
                          ),
                          backgroundColor: Colors.white,
                          content: Text(
                            "Please enter a name",
                            style: TextStyle(
                              color: COLORS().primaryColor,
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                      );
                    } else {
                      DbHelper dbHelper = DbHelper();
                      await dbHelper.addName(name);
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => HomePage(),
                        ),
                      );
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                          (Set<MaterialState> states) {
                        if (states.contains(MaterialState.pressed)) {
                          return COLORS().primaryColor;
                        }
                        return COLORS().primaryColor;
                      },),
                      shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          12.0,
                        ),
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Let's Start",
                        style: TextStyle(
                          fontSize: 25,
                        ),
                      ),
                      SizedBox(
                        width: 8.0,
                      ),
                      Icon(
                        Icons.arrow_right_alt_outlined,
                        size: 35,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
