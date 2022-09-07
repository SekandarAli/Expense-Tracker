// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pdf_render/pdf_render_widgets.dart';
import 'package:share_plus/share_plus.dart';

class ScreenShowPdf extends StatefulWidget {
  final File pdfFile;

  ScreenShowPdf({required this.pdfFile});

  @override
  State<ScreenShowPdf> createState() => _ScreenShowPdfState();
}

class _ScreenShowPdfState extends State<ScreenShowPdf> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text("PDF"),
          leading: InkWell(
            onTap: () {
              Navigator.pop(context, false);
            },
            child: Icon(Icons.arrow_back, color: Colors.white),
          ),
          actions: [
            InkWell(
              onTap: () {
                Share.shareFiles([(widget.pdfFile.path)],
                    text: 'Invoice App');
              },
              child: Padding(
                padding:  EdgeInsets.symmetric(horizontal: 20),
                child: Icon(Icons.share, size: 25, color: Colors.white),
              ),
            )
          ],
        ),
        body: PdfViewer.openFile(widget.pdfFile.path));
  }
}
