import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:http/http.dart' as http;

class PdfService {
  PdfService._();

  /// Load TTF Font
  static Future<pw.Font> loadFont(String path) async {
    return pw.Font.ttf(
      await rootBundle.load(path),
    );
  }

  /// Load Image Asset
  static Future<pw.MemoryImage> loadImage(String path) async {
    final bytes = await rootBundle.load(path);

    return pw.MemoryImage(
      bytes.buffer.asUint8List(),
    );
  }

  /// Download / Share PDF
  static Future<void> download({
    required String fileName,
    required pw.Widget child,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(24),
        build: (_) => [
          child,
        ],
      ),
    );

    await Printing.sharePdf(
      bytes: await pdf.save(),
      filename: fileName,
    );
  }
  static Future<pw.MemoryImage> loadNetworkImage(String url) async {
  final response = await http.get(Uri.parse(url));

  if (response.statusCode != 200) {
    throw Exception('Failed to load image');
  }

  return pw.MemoryImage(response.bodyBytes);
}

  /// Preview PDF
  static Future<void> preview({
    required pw.Widget child,
  }) async {
    await Printing.layoutPdf(
      onLayout: (format) async {
        final pdf = pw.Document();

        pdf.addPage(
          pw.MultiPage(
            pageFormat: PdfPageFormat.a4,
            margin: const pw.EdgeInsets.all(24),
            build: (_) => [
              child,
            ],
          ),
        );

        return pdf.save();
      },
    );
  }
}