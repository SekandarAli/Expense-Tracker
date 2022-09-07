import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../pdf/model/model_pdf.dart';

class PdfListExpenseDetails {
  static Future<File> saveDocument(String name, Document pdf) async {
    final bytes = await pdf.save();

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$name');

    await file.writeAsBytes(bytes);

    return file;
  }

  static Future<File> generate(
      List<Invoice> list_expense, String pdf_name) async {
    final pdf = pw.Document();

    pdf.addPage(
      MultiPage(
        margin: pw.EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        pageFormat: PdfPageFormat.letter,
        build: (context) => [
          buildHeaderView(),
          Padding(
            padding: pw.EdgeInsets.symmetric(vertical: 10),
            child: pw.Divider(),
          ),
          GetItemListTableView(list_expense),
          Padding(
            padding: pw.EdgeInsets.symmetric(vertical: 5),
            child: pw.Divider(),
          ),
        ],
      ),
    );

    return saveDocument(pdf_name, pdf);
  }

  static Widget GetItemListTableView(List<Invoice> list_expense) {
    final titleStyle = TextStyle(
        fontWeight: FontWeight.bold, color: PdfColors.black, fontSize: 20);
    final subtitleStyle = TextStyle(color: PdfColors.black, fontSize: 17);
    final headers = ['Item', 'Category', 'Spent By', 'Amount', 'Cleared'];

    return ListView(
        padding: pw.EdgeInsets.all(10),
        children: list_expense
            .map(
              (e) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Date: ${e.items}", style: titleStyle),
                        // Text(e.is_cleared == "true" ? "Cleared" : "Pending",
                        //     style: titleStyle),
                      ]),
                  SizedBox(height: 25),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(headers[0], style: titleStyle),
                            SizedBox(height: 10),
                            Text("e.items", style: subtitleStyle),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(headers[1], style: titleStyle),
                            SizedBox(height: 10),
                            Text("e.category", style: subtitleStyle),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(headers[2], style: titleStyle),
                            SizedBox(height: 10),
                            Text("e.spentBy", style: subtitleStyle),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(headers[3], style: titleStyle),
                            SizedBox(height: 10),
                            Text("e.amount", style: subtitleStyle),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: pw.EdgeInsets.all(10),
                    child: Text("Shared By", style: titleStyle),
                  ),
                  Wrap(
                    children: e.items!
                        .map((item) => Container(
                              padding: pw.EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 15),
                              margin: pw.EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: PdfColors.blue900,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(25))),
                              child: Text("$item",
                                  style: subtitleStyle.copyWith(
                                      color: PdfColors.white, fontSize: 19)),
                            ))
                        .toList(),
                  ),
                  Divider(height: 20),
                ],
              ),
            )
            .toList());
  }

  static Widget buildHeaderView() {
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
                'Expense List',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 25),
            ],
          )
        ],
      ),
    );
  }
}
