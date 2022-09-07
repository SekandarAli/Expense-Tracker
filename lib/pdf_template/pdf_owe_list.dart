import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfOweList {
  static Future<File> saveDocument(String name, Document pdf) async {
    final bytes = await pdf.save();

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$name');

    await file.writeAsBytes(bytes);

    return file;
  }

  static Future<File> generate(List<Map<String, dynamic>> final_detail_list,
      String pdf_name, int index) async {
    final pdf = pw.Document();

    pdf.addPage(
      MultiPage(
        margin: pw.EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        pageFormat: PdfPageFormat.letter,
        build: (context) => [
          buildHeaderView(index),
          Padding(
            padding: pw.EdgeInsets.symmetric(vertical: 10),
            child: pw.Divider(),
          ),
          GetItemListTableView(final_detail_list, index),
          Padding(
            padding: pw.EdgeInsets.symmetric(vertical: 5),
            child: pw.Divider(),
          ),
        ],
      ),
    );

    return saveDocument(pdf_name, pdf);
  }

  static Widget GetItemListTableView(
      List<Map<String, dynamic>> final_detail_list, int index) {
    final titleStyle = TextStyle(
        fontWeight: FontWeight.bold, color: PdfColors.black, fontSize: 25);
    final subtitleStyle = TextStyle(color: PdfColors.black, fontSize: 20);
    final headers = ['Name', 'Amount'];

    // name
    // amount

    print("object : final_detail_list ${final_detail_list.length}");
    // print("object : final_detail_list ${final_detail_list[].toString()}");
    if (index == 0) {
      return ListView(
          padding: pw.EdgeInsets.all(20),
          children: final_detail_list.map(
            (e) {
              // PdfColor _color = PdfColors.teal;
              //
              // String description = "";
              // if (e["amount"] < 0) {
              //   description = "${e["name"]!} will give ${e["amount"].abs()}";
              //   _color = PdfColors.red;
              // } else {
              //   description = "${e["name"]!} will get ${e["amount"]}";
              //   _color = PdfColors.teal;
              // }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10),
                      Text(e["name"]!, style: titleStyle),
                      SizedBox(height: 10),
                      Text(
                          double.parse(e["amount"]) < 0
                              ? "${e["name"]!} will give ${double.parse(e["amount"]).abs()}"
                              : "${e["name"]!} will get ${e["amount"]}",
                          style: subtitleStyle.copyWith(
                              color: double.parse(e["amount"]) < 0
                                  ? PdfColors.red
                                  : PdfColors.teal,
                              fontSize: 22)),
                    ],
                  ),
                  SizedBox(height: 15),
                  Divider(height: 30),
                ],
              );
            },
          ).toList());
    } else {
      return ListView(
          padding: pw.EdgeInsets.all(20),
          children: final_detail_list
              .map(
                (e) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(headers[0], style: titleStyle),
                              SizedBox(height: 10),
                              Text(e["name"]!, style: subtitleStyle),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(headers[1], style: titleStyle),
                              SizedBox(height: 10),
                              Text(e["amount"]!, style: subtitleStyle),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Divider(height: 20),
                  ],
                ),
              )
              .toList());
    }
  }

  static Widget buildHeaderView(int index) {
    String title = "";
    if (index == 0) {
      title = "Total Owe";
    } else if (index == 1) {
      title = "Total Spend";
    } else if (index == 2) {
      title = "Per Head";
    }

    return Container(
      color: PdfColors.white,
      padding: pw.EdgeInsets.symmetric(horizontal: 25, vertical: 15),
      child: Row(
        children: [
          Container(
            height: 50,
            width: 50,
            child: BarcodeWidget(
              barcode: Barcode.qrCode(),
              data: "${DateTime.now().toString()}",
            ),
          ),
          SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            ],
          )
        ],
      ),
    );
  }
}
