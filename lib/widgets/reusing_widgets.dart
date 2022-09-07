// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:expense_tracker/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WidgetReusing {
  SnackBar deleteInfoSnackBar = SnackBar(
    backgroundColor: Colors.redAccent,
    duration: Duration(
      seconds: 2,
    ),
    content: Row(
      children: [
        Icon(
          Icons.delete,
          color: Colors.white,
        ),
        SizedBox(
          width: 6.0,
        ),
        Text(
          "Long Press to delete",
          style: TextStyle(
            fontSize: 16.0,
          ),
        ),
      ],
    ),
  );

  showConfirmDialog(BuildContext context, String title, String content) async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                Colors.red,
              ),
            ),
            child: Text(
              "YES",
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                Colors.green,
              ),
            ),
            child: Text(
              "No",
            ),
          ),
        ],
      ),
    );
  }

  static Widget cardTotalBalance({
    required String value,
    required IconData icon,
    required Color color,
    required String text,
  }) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white60,
            borderRadius: BorderRadius.circular(
              20.0,
            ),
          ),
          padding: EdgeInsets.all(
            6.0,
          ),
          margin: EdgeInsets.only(
            right: 8.0,
          ),
          child: Icon(
            icon,
            size: 28.0,
            color: color,
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              text,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.white70,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget tileExpenseIncome({
    required int value,
    required String note,
    required DateTime date,
    required int index,
    required BuildContext context,
    required Function() onLongPress,
    required Color color,
    required IconData icon,
    required Color iconDataColor,
    required String text,
    required String monthText,
    required String minusPlus,
    required Color textColor,
  }) {
    return InkWell(
      splashColor: COLORS().primaryColor,
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          WidgetReusing().deleteInfoSnackBar,
        );
      },
      onLongPress: () {
        onLongPress();
      },
      child: Container(
        padding: const EdgeInsets.all(18.0),
        margin: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(
            8.0,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          icon,
                          size: 45,
                          color: iconDataColor,
                        ),
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                text,
                                style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w500),
                              ),
                              SizedBox(
                                width: 4.0,
                              ),
                              Text(
                                monthText,
                                style: TextStyle(
                                  color: Colors.grey[800],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "$minusPlus $value",
                      style: TextStyle(
                        fontSize: 24.0,
                        color: textColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    //
                    Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Text(
                        note,
                        style: TextStyle(
                          color: Colors.grey[800],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget monthTabs({
    required Function() onTap,
    required BuildContext context,
    required Color containerColor,
    required String text,
    required Color textColor,
  }) {
    return InkWell(
        onTap: () {
          onTap();
        },
        child: Container(
          height: 50.0,
          width: MediaQuery.of(context).size.width * 0.3,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              8.0,
            ),
            color: containerColor,
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ));
  }

  }
