import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class MyPdfView extends StatefulWidget {
  const MyPdfView({super.key, required this.pdfLink});
  final String pdfLink;

  @override
  State<MyPdfView> createState() => _MyPdfViewState();
}

class _MyPdfViewState extends State<MyPdfView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your PDF File",style: TextStyle(fontWeight: FontWeight.w700),),
        centerTitle: true,
      ),
      body: SfPdfViewer.network(widget.pdfLink,),
    );
  }
}
