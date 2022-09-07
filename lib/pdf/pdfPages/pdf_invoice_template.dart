// ignore_for_file: prefer_const_constructors

import 'dart:io';
import 'package:expense_tracker/models/transaction_model.dart';
import 'package:expense_tracker/pdf/model/model_pdf.dart';
import 'package:flutter/cupertino.dart' as cd;
import 'package:hive/hive.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';
import '../../color.dart';
import 'pdf_api.dart';
import 'package:intl/intl.dart';

class PdfInvoiceApi {
  static List<List> data = [];

  static Future<File> generate(Invoice invoice) async {
    final pdf = Document();

    pdf.addPage(MultiPage(
      build: (context) => [
        // buildHeader(invoice),
        // SizedBox(height: 2 * PdfPageFormat.cm),
        buildTitle(invoice),
        SizedBox(height: 0.8 * PdfPageFormat.cm),
        Divider(
          height: 5,
          thickness: 8,
          color: COLORS().pdfColors,
        ),

        totalBalance(invoice),
        SizedBox(height: 1.2 * PdfPageFormat.cm),
        incomeExpense(invoice),
        SizedBox(height: 0.6 * PdfPageFormat.cm),
        Divider(),
        SizedBox(height: 0.2 * PdfPageFormat.cm),
        recentTrans(invoice),
        buildInvoice(invoice),

        ///
        ///
        ///
        ///
      ],
      footer: (context) => buildFooter(invoice.userData),
    ));

    return PdfApi.saveDocument(name: 'my_invoice.pdf', pdf: pdf);
  }

  static Widget buildHeader(Invoice invoice) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 1 * PdfPageFormat.cm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(children: [
                buildInvoiceInfo(invoice.userData),
              ]),
              Container(
                height: 80,
                width: 80,
                child: BarcodeWidget(
                  barcode: Barcode.qrCode(),
                  data: invoice.userData.name,
                  // color: COLORS().PdfColors,
                  color: PdfColors.yellow,
                ),
              ),
            ],
          ),
        ],
      );

  static Widget buildInvoiceInfo(UserData info) {
    final titles = <String>[
      'User Name:',
      'Current Month:',
      'Today Date:',
    ];
    final data = <String>[
      info.name,
      info.monthName,
      Utils.formatDate(info.date),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: List.generate(titles.length, (index) {
        final title = titles[index];
        final value = data[index];

        return buildText(title: title, value: value, width: 200);
      }),
    );
  }

  static Widget buildTitle(Invoice invoice) => Center(
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        Container(
          height: 40,
          width: 40,
          child: BarcodeWidget(
            barcode: Barcode.qrCode(),
            data: invoice.userData.name,
            color: COLORS().pdfColors,
          ),
        ),
        SizedBox(height: 0.4 * PdfPageFormat.cm),
        Column(
          children: [
            Text(
              'EXPENSE INVOICE ',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        Container(height: 50, width: 50, child: Container()),
      ]));

  static Widget totalBalance(Invoice invoice) => Center(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 0.8 * PdfPageFormat.cm),
          Text(
            'BALANCE',
            style: TextStyle(
                color: COLORS().pdfColors,
                fontSize: 26,
                letterSpacing: 8,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 0.4 * PdfPageFormat.cm),
          Text(
            "Rs ${invoice.expenseData.totalBalance}",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.normal),
          ),
        ],
      ));

  static Widget incomeExpense(Invoice invoice) => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(children: [
                  Text(
                    'INCOME',
                    style: TextStyle(
                        color: PdfColors.green900,
                        fontSize: 30,
                        letterSpacing: 4,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 0.4 * PdfPageFormat.cm),
                  Text(
                    invoice.expenseData.totalIncome,
                    style:
                        TextStyle(fontSize: 28, fontWeight: FontWeight.normal),
                  ),
                ]),
                Column(children: [
                  Text(
                    'EXPENSE',
                    style: TextStyle(
                        color: PdfColors.red900,
                        fontSize: 30,
                        letterSpacing: 4,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 0.4 * PdfPageFormat.cm),
                  Text(
                    invoice.expenseData.totalExpense,
                    style:
                        TextStyle(fontSize: 28, fontWeight: FontWeight.normal),
                  ),
                ])
              ]),
          SizedBox(height: 0.8 * PdfPageFormat.cm),
        ],
      );

  static Widget creditTile(Invoice invoice) {
    final headers = [
      'Title',
      'Date',
      'Price',
      'Note',
    ];
    final data = invoice.items!.map((item) {
      return [
        item.type,
        'Rs ${item.amount}',
        Utils.formatDate(item.date),
        (item.note),
      ];
    }).toList();

    return Table.fromTextArray(
      headers: headers,
      data: data,
      border: null,
      headerStyle:
          TextStyle(fontWeight: FontWeight.bold, color: PdfColors.white),
      headerDecoration: BoxDecoration(color: PdfColors.purple900),
      cellHeight: 30,
      cellAlignments: {
        0: Alignment.centerLeft,
        1: Alignment.centerLeft,
        2: Alignment.centerLeft,
        3: Alignment.centerRight,
      },
    );
  }

  static Widget buildFooter(UserData invoice) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(),
          SizedBox(height: 2 * PdfPageFormat.mm),
          buildSimpleText(title: 'NAME', value: invoice.name),
          SizedBox(height: 1 * PdfPageFormat.mm),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            buildSimpleText(title: 'MONTH', value: invoice.monthName),
            buildSimpleText(
                title: 'DATE', value: Utils.formatDate(invoice.date)),
          ]),
          // SizedBox(height: 1 * PdfPageFormat.mm),
          // buildSimpleText(
          //     title: 'This is official from Expense Tracker App', value: ""),
        ],
      );

  static buildSimpleText({
    required String title,
    required String value,
  }) {
    final style = TextStyle(fontWeight: FontWeight.bold);

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: pw.CrossAxisAlignment.end,
      children: [
        Text(title, style: style),
        SizedBox(width: 2 * PdfPageFormat.mm),
        Text(value),
      ],
    );
  }

  static buildText({
    required String title,
    required String value,
    double width = double.infinity,
    TextStyle? titleStyle,
    bool unite = false,
  }) {
    final styleLeft =
        titleStyle ?? TextStyle(fontWeight: FontWeight.bold, fontSize: 15);
    final styleRight =
        titleStyle ?? TextStyle(fontWeight: FontWeight.normal, fontSize: 15);

    return Container(
      width: width,
      child: Row(
        children: [
          Expanded(child: Text(title, style: styleLeft)),
          Text(value, style: styleRight),
        ],
      ),
    );
  }

  static Widget recentTrans(Invoice invoice) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            'Recent Transaction',
            style: TextStyle(
                color: PdfColors.orange900,
                fontSize: 26,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 0.4 * PdfPageFormat.cm),
        ],
      );

  static Widget buildInvoice(Invoice modelInvoice) {
    final header = [
      'Amount',
      'Type',
      'Note',
      'Date',
    ];

    data = modelInvoice.items!.map((item) {
      return [
        item.amount,
        item.type == "Income" ? item.type : item.type,
        item.note,
        item.date,
      ];
    }).toList();

    return Table.fromTextArray(
      headers: header,
      data: data,
      rowDecoration: BoxDecoration(
          // color: modelInvoice.items.map((e) =>
          //     e.type == "rrr" ? PdfColors.deepPurple100 : PdfColors.yellow)),
      color : PdfColors.purple100),
      cellStyle: TextStyle(
          fontWeight: FontWeight.bold, fontSize: 13, color: PdfColors.black),
      border: TableBorder.all(
        width: 2,
        style: BorderStyle.solid,
        color: COLORS().pdfColors,
      ),
      headerStyle: TextStyle(
          fontWeight: FontWeight.bold, fontSize: 15, color: PdfColors.white),
      headerDecoration: BoxDecoration(color: COLORS().pdfColors),
      cellHeight: 50,
      cellAlignments: {
        0: Alignment.center,
        1: Alignment.center,
        2: Alignment.center,
        3: Alignment.center,
      },
    );
  }
}

class Utils {
  static formatPrice(double price) => '\$ ${price.toStringAsFixed(2)}';

  static formatDate(DateTime date) => DateFormat.yMd().format(date);
}
