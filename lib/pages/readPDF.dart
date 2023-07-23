import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
class ReadPDF extends StatefulWidget {
 final String pdf;
 final String name;
  const ReadPDF({super.key,required this.pdf, required this.name});

  @override
  State<ReadPDF> createState() => _ReadPDFState();
}

class _ReadPDFState extends State<ReadPDF> {
  PdfViewerController? _pdfViewerController;

  @override
  void initState() {
    _pdfViewerController = PdfViewerController();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.zoom_in,
              color: Colors.white,
            ),
            onPressed: () {
              _pdfViewerController?.zoomLevel = 2;
            },
          ),
        ],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [

          FloatingActionButton(
           child: SvgPicture.asset(
                "./assets/svgs/arrow-left.svg",
                color:Colors.white
            ),
            onPressed: () {
              _pdfViewerController?.previousPage();
            },

          ),
          Padding(padding: EdgeInsets.only(left:10)),
          FloatingActionButton(
           child: SvgPicture.asset(
                "./assets/svgs/arrow-right.svg",
                color:Colors.white
            ),
            onPressed: () {
              _pdfViewerController?.nextPage();

            },

          ),
        ],
      ),
      body: SfPdfViewer.network(
        widget.pdf,
        controller: _pdfViewerController,
      ),
    );
  }
}
