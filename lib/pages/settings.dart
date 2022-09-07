// ignore_for_file: prefer_const_constructors

import 'package:expense_tracker/color.dart';
import 'package:expense_tracker/controllers/db_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/reusing_widgets.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  //

  DbHelper dbHelper = DbHelper();

  //
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: Text(
          "Settings"
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(
          12.0,
        ),
        children: [
          //
          ListTile(
            onTap: () async {
              String nameEditing = "";
              String? name = await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  backgroundColor: Colors.grey[300],
                  title: Text(
                    "Enter new name",
                  ),
                  content: Container(
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
                      decoration: InputDecoration(
                        hintText: "Your Name",
                        border: InputBorder.none,
                      ),
                      style: TextStyle(
                        fontSize: 20.0,
                      ),
                      // maxLength: 12,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(9),
                      ],
                      onChanged: (val) {
                        nameEditing = val;
                      },
                    ),
                  ),
                  actions: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop(nameEditing);
                      },
                      style: ElevatedButton.styleFrom(
                          primary: COLORS().primaryColor),
                      child: Text(
                        "OK",
                      ),
                    ),
                  ],
                ),
              );
              //
              if (name != null && name.isNotEmpty) {
                DbHelper dbHelper = DbHelper();
                await dbHelper.addName(name);
              }
            },
            tileColor: Colors.white,
            contentPadding: EdgeInsets.symmetric(
              vertical: 12.0,
              horizontal: 20.0,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                8.0,
              ),
            ),
            title: Text(
              "Change Name",
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w800,
              ),
            ),
            subtitle: Text(
              "Welcome {your_new_name}",
            ),
            trailing: Icon(
              Icons.change_circle,
              size: 32.0,
              color: Colors.black87,
            ),
          ),

          SizedBox(
            height: 20.0,
          ),
          //
          ListTile(
            onTap: () async {
              bool answer = await WidgetReusing().showConfirmDialog(
                  context,
                  "Warning",
                  "This is irreversible. Your entire data will be Lost");
              if (answer) {
                await dbHelper.cleanData();
                Navigator.of(context).pop();
              }
            },
            tileColor: Colors.white,
            contentPadding: EdgeInsets.symmetric(
              vertical: 12.0,
              horizontal: 20.0,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                8.0,
              ),
            ),
            title: Text(
              "Clean Data",
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w800,
              ),
            ),
            subtitle: Text(
              "This is irreversible and your data will be remove",
            ),
            trailing: Icon(
              Icons.delete_forever,
              size: 32.0,
              color: Colors.red.shade600,
            ),
          ),

          //
          SizedBox(
            height: 20.0,
          ),

          ListTile(
            onTap: () async {
              bool answer = await WidgetReusing().showConfirmDialog(
                  context,
                  "Theme",
                  "Change your Theme");
              if (answer) {
                Navigator.of(context).pop();
              }
            },
            tileColor: Colors.white,
            contentPadding: EdgeInsets.symmetric(
              vertical: 12.0,
              horizontal: 20.0,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                8.0,
              ),
            ),
            title: Text(
              "Theme",
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w800,
              ),
            ),
            subtitle: Text(
              "Change Your Theme to Dark or Light",
            ),
            trailing: Icon(
              Icons.dark_mode,
              size: 32.0,
              color: Colors.black,
            ),
          ),

          //
          // FutureBuilder<bool>(
          //   future: dbHelper.getLocalAuth(),
          //   builder: (context, snapshot) {
          //     // print(snapshot.data);
          //     if (snapshot.hasData) {
          //       return SwitchListTile(
          //         onChanged: (val) {
          //           DbHelper dbHelper = DbHelper();
          //           dbHelper.setLocalAuth(val);
          //           setState(() {});
          //         },
          //         value: snapshot.data == null ? false : snapshot.data!,
          //         tileColor: Colors.white,
          //         contentPadding: EdgeInsets.symmetric(
          //           vertical: 12.0,
          //           horizontal: 20.0,
          //         ),
          //         shape: RoundedRectangleBorder(
          //           borderRadius: BorderRadius.circular(
          //             8.0,
          //           ),
          //         ),
          //         title: Text(
          //           "Local Bio Auth",
          //           style: TextStyle(
          //             fontSize: 20.0,
          //             fontWeight: FontWeight.w800,
          //           ),
          //         ),
          //         subtitle: Text(
          //           "Secure This app, Use Fingerprint to unlock the app.",
          //         ),
          //       );
          //     } else {
          //       return Container();
          //     }
          //   },
          // ),
        ],
      ),
    );
  }
}
