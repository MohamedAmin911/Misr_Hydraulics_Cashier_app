import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../domain/models/sale_transaction.dart';
import '../../domain/models/transaction_item.dart';
import '../app_config.dart';
import 'currency_formatter.dart';

class PdfReceiptBuilder {
  static Future<Uint8List> build({
    required SaleTransaction tx,
    required bool
    forAdmin, // admin: show cost & profit, seller: only sell price
  }) async {
    final fontRegular = pw.Font.ttf(
      await rootBundle.load('packages/shared/assets/fonts/Tajawal-Regular.ttf'),
    );
    final fontBold = pw.Font.ttf(
      await rootBundle.load('packages/shared/assets/fonts/Tajawal-Bold.ttf'),
    );

    final pdf = pw.Document();
    final dateStr = DateFormat('yyyy-MM-dd HH:mm').format(tx.date);

    pw.Widget buildHeader() {
      return pw.Align(
        alignment: pw.Alignment.centerRight,
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              AppConfig.companyName,
              style: pw.TextStyle(font: fontBold, fontSize: 20),
              textAlign: pw.TextAlign.right,
            ),
            pw.SizedBox(height: 5),
            pw.Text(
              'إيصال عملية',
              style: pw.TextStyle(font: fontRegular, fontSize: 16),
              textAlign: pw.TextAlign.right,
            ),
            pw.SizedBox(height: 3),
            pw.Text(
              'رقم العملية: ${tx.id}',
              style: pw.TextStyle(font: fontRegular, fontSize: 12),
              textAlign: pw.TextAlign.right,
            ),
            pw.SizedBox(height: 3),
            pw.Text(
              'التاريخ: $dateStr',
              style: pw.TextStyle(font: fontRegular, fontSize: 12),
              textAlign: pw.TextAlign.right,
            ),
            pw.SizedBox(height: 3),
            pw.Text(
              'الموظف (البائع): ${tx.sellerId}',
              style: pw.TextStyle(font: fontRegular, fontSize: 12),
              textAlign: pw.TextAlign.right,
            ),
          ],
        ),
      );
    }

    pw.Widget buildItemsTable() {
      final headers = forAdmin
          ? ['الإجمالي', 'الكمية', 'سعر البيع', 'التكلفة', 'المنتج']
          : ['الإجمالي', 'الكمية', 'السعر', 'المنتج'];

      final List<List<String>> data = [];

      for (final TransactionItem it in tx.items) {
        final totalSell = it.sellPriceAtSale * it.quantity;
        if (forAdmin) {
          data.add([
            CurrencyFormatter.format(totalSell),
            it.quantity.toString(),
            CurrencyFormatter.format(it.sellPriceAtSale),
            CurrencyFormatter.format(it.buyPriceAtSale),
            it.productId,
          ]);
        } else {
          data.add([
            CurrencyFormatter.format(totalSell),
            it.quantity.toString(),
            CurrencyFormatter.format(it.sellPriceAtSale),
            it.productId,
          ]);
        }
      }

      // Right-align every column
      final Map<int, pw.Alignment> alignments = {
        0: pw.Alignment.centerRight,
        1: pw.Alignment.centerRight,
        2: pw.Alignment.centerRight,
        3: pw.Alignment.centerRight,
        if (forAdmin) 4: pw.Alignment.centerRight,
      };

      // Put table inside a Row aligned to end so the entire table sits on the right
      return pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.end,
        children: [
          pw.Container(
            // optional: constrain max width so it doesn't look too wide
            constraints: const pw.BoxConstraints(maxWidth: 520),
            child: pw.Table.fromTextArray(
              headers: headers,
              data: data,
              headerStyle: pw.TextStyle(font: fontBold, fontSize: 12),
              cellStyle: pw.TextStyle(font: fontRegular, fontSize: 11),
              headerDecoration: pw.BoxDecoration(color: PdfColors.grey300),
              border: null,
              headerAlignments: alignments,
              cellAlignments: alignments,
            ),
          ),
        ],
      );
    }

    pw.Widget buildTotals() {
      return pw.Align(
        alignment: pw.Alignment.centerRight,
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.end,
          children: [
            pw.Divider(),
            pw.Text(
              'إجمالي المبيعات: ${CurrencyFormatter.format(tx.totalSell)}',
              style: pw.TextStyle(font: fontBold, fontSize: 12),
              textAlign: pw.TextAlign.right,
            ),
            pw.SizedBox(height: 3),
            if (forAdmin) ...[
              pw.Text(
                'إجمالي التكلفة: ${CurrencyFormatter.format(tx.totalCost)}',
                style: pw.TextStyle(font: fontRegular, fontSize: 12),
                textAlign: pw.TextAlign.right,
              ),
              pw.SizedBox(height: 3),
              pw.Text(
                'صافي الربح: ${CurrencyFormatter.format(tx.totalProfit)}',
                style: pw.TextStyle(font: fontBold, fontSize: 13),
                textAlign: pw.TextAlign.right,
              ),
            ],
          ],
        ),
      );
    }

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        textDirection: pw.TextDirection.rtl, // Arabic text shaping
        build: (context) => pw.Padding(
          padding: const pw.EdgeInsets.all(24),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.stretch,
            children: [
              buildHeader(),
              pw.SizedBox(height: 16),
              buildItemsTable(),
              pw.SizedBox(height: 12),
              buildTotals(),
            ],
          ),
        ),
      ),
    );

    return pdf.save();
  }
}
