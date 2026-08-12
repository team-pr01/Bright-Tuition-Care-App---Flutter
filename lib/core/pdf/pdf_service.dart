import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PdfService {
  PdfService._();

  static const MethodChannel _channel = MethodChannel(
    'com.prtechsolutions.btc.btcclient/pdf_download',
  );

  // ============================================================
  // LOAD TTF FONT
  // ============================================================

  static Future<pw.Font> loadFont(String path) async {
    final data = await rootBundle.load(path);

    return pw.Font.ttf(data.buffer.asByteData());
  }

  // ============================================================
  // LOAD ASSET IMAGE
  // ============================================================

  static Future<pw.MemoryImage> loadImage(String path) async {
    final data = await rootBundle.load(path);

    return pw.MemoryImage(data.buffer.asUint8List());
  }

  // ============================================================
  // LOAD NETWORK IMAGE
  // ============================================================

  static Future<pw.MemoryImage> loadNetworkImage(String url) async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode != 200) {
      throw Exception('Failed to load image: ${response.statusCode}');
    }

    return pw.MemoryImage(response.bodyBytes);
  }

  // ============================================================
  // BUILD PDF FROM WIDGET
  // ============================================================

  static Future<Uint8List> buildPdf({
    required pw.Widget child,
    PdfPageFormat pageFormat = PdfPageFormat.a4,
    pw.EdgeInsets margin = const pw.EdgeInsets.all(24),
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: pageFormat,
        margin: margin,
        build: (context) => [child],
      ),
    );

    return pdf.save();
  }

  // ============================================================
  // SAVE PDF DIRECTLY TO ANDROID DOWNLOADS
  // ============================================================

  static Future<bool> downloadBytes({
    required String fileName,
    required Uint8List bytes,
  }) async {
    try {
      final result = await _channel.invokeMethod<bool>('savePdfToDownloads', {
        'fileName': _ensurePdfExtension(fileName),
        'bytes': bytes,
      });

      return result ?? false;
    } on PlatformException catch (e) {
      throw Exception('Failed to save PDF: ${e.message ?? e.code}');
    } catch (e) {
      throw Exception('Failed to save PDF: $e');
    }
  }

  // ============================================================
  // OPTIONAL:
  // BUILD + DOWNLOAD IN ONE CALL
  // ============================================================

  static Future<bool> download({
    required String fileName,
    required pw.Widget child,
  }) async {
    final bytes = await buildPdf(child: child);

    return downloadBytes(fileName: fileName, bytes: bytes);
  }

  // ============================================================
  // PDF PREVIEW
  // ============================================================

  static Future<void> preview({required pw.Widget child}) async {
    await Printing.layoutPdf(
      onLayout: (format) async {
        return buildPdf(child: child, pageFormat: format);
      },
    );
  }

  // ============================================================
  // ENSURE .PDF EXTENSION
  // ============================================================

  static String _ensurePdfExtension(String fileName) {
    if (fileName.toLowerCase().endsWith('.pdf')) {
      return fileName;
    }

    return '$fileName.pdf';
  }

  // ============================================================
  // SANITIZE FILE NAME
  // ============================================================

  static String sanitizeFileName(String value) {
    return value
        .replaceAll(RegExp(r'[\\/:*?"<>|]'), '_')
        .replaceAll(RegExp(r'\s+'), '_')
        .trim();
  }
}
