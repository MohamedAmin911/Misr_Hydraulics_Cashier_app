import 'dart:typed_data';
import 'package:printing/printing.dart';

class PrintingService {
  static Future<void> printPdf(Uint8List bytes) async {
    await Printing.layoutPdf(onLayout: (_) async => bytes);
  }

  static Future<void> directPrintIfSupported(Uint8List bytes) async {
    // On Windows this may still show the dialog. We try silent print if available.
    await printPdf(bytes);
  }
}
