// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:expense_tracker/controllers/db_helper.dart';
import 'package:expense_tracker/color.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddTransaction extends StatefulWidget {
   AddTransaction({Key? key, this.price}) : super(key: key);

  int? price;

  @override
  _AddTransactionState createState() => _AddTransactionState();
}

class _AddTransactionState extends State<AddTransaction> {
  DateTime selectedDate = DateTime.now();
  int? amount;
  String note = "No Note Added";
  String type = "Income";

  TextEditingController price = TextEditingController();

  List<String> months = [
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec"
  ];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2020),
        lastDate: DateTime(2030),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: COLORS().primaryColor,
                onPrimary: Colors.white,
                onSurface: Colors.black,
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  primary: COLORS().primaryColor, // button text color
                ),
              ),
            ),
            child: child!,
          );
        });
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: COLORS().backgroundColor,
      //
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(
            12,
          ),
          children: [
            // SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  color: Colors.black,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.arrow_back_ios_new_sharp,size: 30,color: Colors.black),
                ),
                Text(
                  "Add Transaction\t\t\t",
                  style: TextStyle(
                    fontSize: 32.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(""),
              ],
            ),
            //
            SizedBox(
              height: 30.0,
            ),
            //
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: COLORS().primaryColor,
                    borderRadius: BorderRadius.circular(
                      16.0,
                    ),
                  ),
                  padding: EdgeInsets.all(
                    12.0,
                  ),
                  child: Icon(
                    Icons.attach_money,
                    size: 24.0,
                    // color: Colors.grey[700],
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  width: 12.0,
                ),
                Expanded(
                  child: TextField(
                    controller: price,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(10),
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    cursorColor: COLORS().primaryColor,
                    cursorWidth: 6,
                    decoration: InputDecoration(
                      hintText: " 0",
                      border: InputBorder.none,
                    ),
                    style: TextStyle(
                      fontSize: 24.0,
                    ),
                    onChanged: (val) {
                      try {
                        amount = int.parse(val);
                      } catch (e) {
                        // show Error
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.red,
                            duration: Duration(
                              seconds: 2,
                            ),
                            content: Row(
                              children: [
                                Icon(
                                  Icons.info_outline,
                                  color: Colors.white,
                                ),
                                SizedBox(
                                  width: 6.0,
                                ),
                                Text(
                                  "Enter only Numbers as Amount",
                                  style: TextStyle(
                                    fontSize: 16.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                    },
                    keyboardType: TextInputType.number,
                    // textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            //
            SizedBox(
              height: 20.0,
            ),
            //
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: COLORS().primaryColor,
                    borderRadius: BorderRadius.circular(
                      16.0,
                    ),
                  ),
                  padding: EdgeInsets.all(
                    12.0,
                  ),
                  child: Icon(
                    Icons.description,
                    size: 24.0,
                    // color: Colors.grey[700],
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  width: 12.0,
                ),
                Expanded(
                  child: TextField(
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(20),
                    ],
                    cursorColor: COLORS().primaryColor,
                    cursorWidth: 6,
                    decoration: InputDecoration(
                      hintText: " Note on Transaction",
                      border: InputBorder.none,
                    ),
                    style: TextStyle(
                      fontSize: 20.0,
                    ),
                    onChanged: (val) {
                      note = val;
                    },
                  ),
                ),
              ],
            ),
            //
            SizedBox(
              height: 20.0,
            ),
            //
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: COLORS().primaryColor,
                    borderRadius: BorderRadius.circular(
                      16.0,
                    ),
                  ),
                  padding: EdgeInsets.all(
                    12.0,
                  ),
                  child: Icon(
                    Icons.money,
                    size: 24.0,
                    // color: Colors.grey[700],
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  width: 12.0,
                ),
                ChoiceChip(
                  label: Text(
                    "Income",
                    style: TextStyle(
                      fontSize: 20,
                      color: type == "Income" ? Colors.white : Colors.black,
                    ),
                  ),
                  selectedColor: Colors.green,
                  onSelected: (val) {
                    if (val) {
                      setState(() {
                        type = "Income";
                        if (note.isEmpty || note == "Expense") {
                          note = 'Income';
                        }
                      });
                    }
                  },
                  selected: type == "Income" ? true : false,
                ),
                SizedBox(
                  width: 8.0,
                ),
                ChoiceChip(
                  label: Text(
                    "Expense",
                    style: TextStyle(
                      fontSize: 20,
                      color: type == "Expense" ? Colors.white : Colors.black,
                    ),
                  ),
                  selectedColor: Colors.redAccent,
                  onSelected: (val) {
                    if (val) {
                      setState(() {
                        type = "Expense";

                        if (note.isEmpty || note == "Income") {
                          note = 'Expense';
                        }
                      });
                    }
                  },
                  selected: type == "Expense" ? true : false,
                ),
              ],
            ),
            //
            SizedBox(
              height: 20.0,
            ),
            //
            SizedBox(
              height: 50.0,
              child: TextButton(
                onPressed: () {
                  _selectDate(context);
                  FocusScope.of(context).unfocus();
                },
                style: ButtonStyle(
                  padding: MaterialStateProperty.all(
                    EdgeInsets.zero,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: COLORS().primaryColor,
                        borderRadius: BorderRadius.circular(
                          16.0,
                        ),
                      ),
                      padding: EdgeInsets.all(
                        12.0,
                      ),
                      child: Icon(
                        Icons.date_range,
                        size: 24.0,
                        // color: Colors.grey[700],
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      width: 12.0,
                    ),
                    Text(
                      "${selectedDate.day} ${months[selectedDate.month - 1]} ${selectedDate.year}",
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            //
            SizedBox(
              height: 30,
            ),
            //
            SizedBox(
              height: 60.0,
              child: ElevatedButton(
                onPressed: () {
                  if (amount != null) {
                    DbHelper dbHelper = DbHelper();
                    dbHelper.addData(amount!, selectedDate, type, note);
                    Navigator.of(context).pop();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: Colors.red[700],
                        content: Text(
                          "Please enter Amount !",
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(primary: COLORS().primaryColor),
                child: Text(
                  "Add",
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
