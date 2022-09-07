// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously, prefer_const_constructors_in_immutables

import 'package:expense_tracker/controllers/db_helper.dart';
import 'package:expense_tracker/pages/add_transaction.dart';
import 'package:expense_tracker/models/transaction_model.dart';
import 'package:expense_tracker/color.dart';
import 'package:expense_tracker/pdf/model/model_pdf.dart';
import 'package:expense_tracker/pdf/pdfPages/pdf_invoice_template.dart';
import 'package:expense_tracker/pdf/pdfPages/pdf_screen_show.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/reusing_widgets.dart';
import 'settings.dart';

class HomePage extends StatefulWidget {
   HomePage({Key? key}) : super(key: key);

  // Invoice? task;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Box box;
  late SharedPreferences preferences;
  DbHelper dbHelper = DbHelper();
  Map? data;
  int totalBalance = 0;
  int totalIncome = 0;
  int totalExpense = 0;
  List<FlSpot> dataSet = [];
  DateTime today = DateTime.now();
  DateTime now = DateTime.now();
  int index = 2;

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

  @override
  void initState() {
    super.initState();
    getPreference();
    box = Hive.box('money');
  }

  getPreference() async {
    preferences = await SharedPreferences.getInstance();
  }

  Future<List<TransactionModel>> fetch() async {
    if (box.values.isEmpty) {
      return Future.value([]);
    } else {
      List<TransactionModel> items = [];
      box.toMap().values.forEach((element) {
        // print(element);
        items.add(
          TransactionModel(
            amount: element['amount'] as int,
            date: element['date'] as DateTime,
            type: element['type'],
            note: element['note'],
          ),
        );
      });
      return items;
    }
  }

  List<FlSpot> getPlotPoints(List<TransactionModel> entireData) {
    dataSet = [];
    List tempdataSet = [];

    for (TransactionModel item in entireData) {
      if (item.date.month == today.month && item.type == "Expense") {
        tempdataSet.add(item);
      }
    }
    tempdataSet.sort((a, b) => a.date.day.compareTo(b.date.day));
    for (var i = 0; i < tempdataSet.length; i++) {
      dataSet.add(
        FlSpot(
          tempdataSet[i].date.day.toDouble(),
          tempdataSet[i].amount.toDouble(),
        ),
      );
    }
    return dataSet;
  }

  getTotalBalance(List<TransactionModel> entireData) {
    totalBalance = 0;
    totalIncome = 0;
    totalExpense = 0;
    for (TransactionModel data in entireData) {
      if (data.date.month == today.month) {
        if (data.type == "Income") {
          totalBalance += data.amount;
          totalIncome += data.amount;
        } else {
          totalBalance -= data.amount;
          totalExpense += data.amount;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0.0,
      ),
      backgroundColor: COLORS().backgroundColor,
      //
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        // color: COLORS().PrimaryColor,
        height: 90,
        width: 90,
        child: FittedBox(
          child: FloatingActionButton(
            onPressed: () {
              Navigator.of(context)
                  .push(
                CupertinoPageRoute(
                  builder: (context) => AddTransaction(),
                ),
              )
                  .then((value) {
                setState(() {});
              });
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                16.0,
              ),
            ),
            backgroundColor: COLORS().primaryColor,
            child: Icon(
              Icons.add_outlined,
              size: 40,
            ),
          ),
        ),
      ),
      //
      body: FutureBuilder<List<TransactionModel>>(
        future: fetch(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Oopssss !!! There is some error !",
                style: TextStyle(
                  fontSize: 24.0,
                ),
              ),
            );
          }
          if (snapshot.hasData) {
            if (snapshot.data!.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      maxRadius: 100,
                      backgroundColor: Colors.transparent,
                      child: LottieBuilder.asset("assets/lottie/person.json",width: 200,height: 200,),
                    ),
                    Text(
                      "Press Button below to Start !",
                      style: TextStyle(
                        fontSize: 25,
                      ),
                    ),
                  ],
                ),
              );
            }
            getTotalBalance(snapshot.data!);
            getPlotPoints(snapshot.data!);
            return ListView(
              children: [
                //
                Padding(
                  padding: const EdgeInsets.all(
                    12.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                32.0,
                              ),
                              // gradient: LinearGradient(
                              //   colors: [
                              //     Colors.green,
                              //     Colors.red,
                              //   ],
                              // ),
                            ),
                            child: CircleAvatar(
                              maxRadius: 30,
                              backgroundColor: Colors.transparent,
                              // child: Image.asset(
                              //   "assets/face.png",
                              //   width: 100,
                              // ),
                              child: LottieBuilder.asset(
                                  "assets/lottie/person.json"),
                            ),
                          ),
                          SizedBox(
                            width: 8.0,
                          ),
                          SizedBox(
                            width: 200.0,
                            child: Text(
                              "Welcome ${preferences.getString('name')}!",
                              style: TextStyle(
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                                color: COLORS().primaryColor,
                              ),
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            12.0,
                          ),
                          color: Colors.white70,
                        ),
                        padding: EdgeInsets.all(
                          12.0,
                        ),
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context)
                                .push(
                              MaterialPageRoute(
                                builder: (context) => Settings(),
                              ),
                            )
                                .then((value) {
                              setState(() {});
                            });
                          },
                          child: Icon(
                            Icons.settings,
                            size: 32.0,
                            color: Color(0xff34393e),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                //
                selectMonth(),
                //
                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  margin: EdgeInsets.all(
                    12.0,
                  ),
                  child: Ink(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.green,
                          Colors.red,
                        ],
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(
                          24.0,
                        ),
                      ),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(
                            24.0,
                          ),
                        ),
                        // color: COLORS().PrimaryColor
                      ),
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(
                        vertical: 18.0,
                        horizontal: 8.0,
                      ),
                      child: Column(
                        children: [
                          SizedBox(height: 10),
                          Text(
                            'Total Balance',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 25,
                              letterSpacing: 5,
                              // fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(
                            height: 12.0,
                          ),
                          Text(
                            'Rs $totalBalance/-',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 36.0,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(
                            height: 12.0,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                WidgetReusing.cardTotalBalance(
                                    value: totalIncome.toString(),
                                    icon: Icons.arrow_downward,
                                    color: Colors.green,
                                    text: "Income"),
                                WidgetReusing.cardTotalBalance(
                                    value: totalExpense.toString(),
                                    icon: Icons.arrow_upward,
                                    color: Colors.red,
                                    text: "Expense"),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                //
                Padding(
                  padding: const EdgeInsets.all(
                    12.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        "${months[today.month - 1]} ${today.year}",
                        // "$months",
                        style: TextStyle(
                          fontSize: 32.0,
                          color: Colors.black87,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.35,
                        height: 50,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            primary: COLORS().primaryColor,
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () async {
                            final date = DateTime.now();
                            final invoice = Invoice(
                              userData: UserData(
                                date: date,
                                monthName:
                                    "${months[today.month - 1]} ${today.year}",
                                name: "${preferences.getString('name')}",
                              ),
                              expenseData: ExpenseData(
                                  totalBalance: "${totalBalance.toString()}/-",
                                  totalIncome: "${totalIncome.toString()}/-",
                                  totalExpense: "${totalExpense.toString()}/-"),
                              items: box.values.map((element) {
                                return TransactionModel(
                                  amount: element['amount'],
                                  date: element['date'],
                                  type: element['type'],
                                  note: element['note'],
                                );
                              }).toList(),
                            );

                            // final pdfFile =
                            //     await PdfListExpenseDetails.generate(
                            //         dataAtIndex, "aaa");

                            final pdfFile =
                                await PdfInvoiceApi.generate(invoice);
                            // PdfApi.openFile(pdfFile);

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ScreenShowPdf(pdfFile: pdfFile)));
                          },
                          icon: Icon(Icons.picture_as_pdf_outlined),
                          label: Text("Show PDF"),
                        ),
                      ),

//////////////////////////////////////////////////////////////////////////////////////
//                        PdfPageScreen(),
/////////////////////////////////////////////////////////////////////////////////////
                    ],
                  ),
                ),
                //
                dataSet.isEmpty || dataSet.length < 2
                    ? Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 40.0,
                          horizontal: 20.0,
                        ),
                        margin: EdgeInsets.all(
                          12.0,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            8.0,
                          ),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset:
                                  Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Text(
                          "Not Enough Data to render Chart",
                          style: TextStyle(
                            fontSize: 20.0,
                          ),
                        ),
                      )
                    : Container(
                        height: 400.0,
                        padding: EdgeInsets.symmetric(
                          vertical: 40.0,
                          horizontal: 12.0,
                        ),
                        margin: EdgeInsets.all(
                          12.0,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(
                            Radius.circular(8),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset:
                                  Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        child: LineChart(
                          swapAnimationDuration: Duration(milliseconds: 150),
                          swapAnimationCurve: Curves.linear,
                          LineChartData(
                            gridData: FlGridData(show: true),
                            borderData: FlBorderData(
                              show: false,
                            ),
                            lineBarsData: [
                              LineChartBarData(
                                spots: getPlotPoints(snapshot.data!),
                                isCurved: true,
                                barWidth: 2.5,
                                color: COLORS().primaryColor,
                                showingIndicators: [200, 200, 90, 10],
                                dotData: FlDotData(
                                  show: true,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                //
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    "Recent Transactions",
                    style: TextStyle(
                      fontSize: 32.0,
                      color: Colors.black87,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                //
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: snapshot.data!.length + 1,
                  itemBuilder: (context, index) {
                    TransactionModel dataAtIndex;
                    try {
                      dataAtIndex = snapshot.data![index];
                    } catch (e) {
                      return Container();
                    }

                    if (dataAtIndex.date.month == today.month) {
                      if (dataAtIndex.type == "Income") {
                        return WidgetReusing().tileExpenseIncome(
                            value: dataAtIndex.amount,
                            note: dataAtIndex.note,
                            date: dataAtIndex.date,
                            index: index,
                            context: context,
                            onLongPress: () async {
                              bool? answer =
                                  await WidgetReusing().showConfirmDialog(
                                context,
                                "WARNING",
                                "This will delete this record. This action is irreversible. Do you want to continue ?",
                              );

                              if (answer != null && answer) {
                                await dbHelper.deleteData(index);
                                setState(() {});
                              }
                            },
                            color: COLORS().greenShadeLight,
                            icon: Icons.arrow_circle_down_outlined,
                            iconDataColor: Colors.green,
                            text: "Credit",
                            monthText:
                                "${dataAtIndex.date.day} ${months[dataAtIndex.date.month - 1]} ",
                            minusPlus: "+",
                            textColor: Colors.green.shade700);
                      } else {
                        return WidgetReusing().tileExpenseIncome(
                            value: dataAtIndex.amount,
                            note: dataAtIndex.note,
                            date: dataAtIndex.date,
                            index: index,
                            context: context,
                            onLongPress: () async {
                              bool? answer =
                                  await WidgetReusing().showConfirmDialog(
                                context,
                                "WARNING",
                                "This will delete this record. This action is irreversible. Do you want to continue ?",
                              );

                              if (answer != null && answer) {
                                await dbHelper.deleteData(index);
                                setState(() {});
                              }
                            },
                            color: COLORS().redShadeLight,
                            icon: Icons.arrow_circle_up_outlined,
                            iconDataColor: Colors.red,
                            text: "Expense",
                            monthText:
                                "${dataAtIndex.date.day} ${months[dataAtIndex.date.month - 1]} ",
                            minusPlus: "-",
                            textColor: Colors.red.shade700);
                      }
                    } else {
                      return Container();
                    }
                  },
                ),
                //
                SizedBox(
                  height: 60.0,
                ),
              ],
            );
          } else {
            return Text(
              "Loading...",
            );
          }
        },
      ),
    );
  }

  Widget selectMonth() {
    return Padding(
      padding: EdgeInsets.all(
        8.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          WidgetReusing().monthTabs(
              onTap: () {
                setState(() {
                  index = 3;
                  // today = DateTime(now.year, now.month - 2, today.day);
                  today = DateTime(now.year, now.month - 1, today.day);
                });
              },
              context: context,
              containerColor:
                  index == 3 ? COLORS().greenShadeDark : Colors.white,
              text: months[now.month - 2],
              textColor: index == 3 ? Colors.white : COLORS().primaryColor),
          WidgetReusing().monthTabs(
              onTap: () {
                setState(() {
                  index = 2;
                  // today = DateTime(now.year, now.month - 1, today.day);
                  today = now;
                });
              },
              context: context,
              containerColor: index == 2 ? COLORS().primaryColor : Colors.white,
              text: months[now.month - 1],
              textColor: index == 2 ? Colors.white : COLORS().primaryColor),
          WidgetReusing().monthTabs(
              onTap: () {
                setState(() {
                  index = 1;
                  today = DateTime(now.year, now.month + 1, today.day);
                  today = DateTime(now.year, now.month + 1, today.day);
                  // today = DateTime.now();
                });
              },
              context: context,
              containerColor: index == 1 ? COLORS().redShadeDark : Colors.white,
              text: months[now.month],
              textColor: index == 1 ? Colors.white : COLORS().primaryColor),
        ],
      ),
    );
  }
}
