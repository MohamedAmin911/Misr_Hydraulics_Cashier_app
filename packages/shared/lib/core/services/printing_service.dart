import 'dart:io';
import 'dart:typed_data';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';

class PrintingService {
  static Future<void> printPdf(
    Uint8List bytes, {
    String jobName = 'إيصال ELAboudy',
  }) async {
    try {
      await Printing.info(); // preflight
      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => bytes,
        name: jobName,
        format: PdfPageFormat.a4,
        dynamicLayout: false,
      );
    } catch (e) {
      // Fallback: save to temp + open/share
      try {
        final dir = await getTemporaryDirectory();
        final path = p.join(
          dir.path,
          'receipt${DateTime.now().millisecondsSinceEpoch}.pdf',
        );
        final f = File(path);
        await f.writeAsBytes(bytes, flush: true);
        try {
          await Printing.sharePdf(bytes: bytes, filename: p.basename(path));
        } catch (e) {
          if (Platform.isWindows) {
            await Process.run('cmd', ['/c', 'start', '', path]);
          }
        }
      } catch (e) {
        // swallow to avoid release crash
      }
    }
  }

  static Future<void> directPrintIfSupported(Uint8List bytes) async {
    await printPdf(bytes);
  }
}
