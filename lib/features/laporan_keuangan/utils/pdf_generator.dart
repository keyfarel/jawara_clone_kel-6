import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';
import '../data/models/finance_report_model.dart';

class PdfGenerator {
  static Future<void> generateAndShow(FinanceReportModel report) async {
    final font = await PdfGoogleFonts.openSansRegular();
    final fontBold = await PdfGoogleFonts.openSansBold();

    final doc = pw.Document();

    final currencyFormat = NumberFormat.currency(
      locale: 'id_ID', 
      symbol: 'Rp ', 
      decimalDigits: 0
    );

    // LOGIKA WARNA SALDO (Baru)
    final isNegative = report.meta.netBalance < 0;
    final balanceColor = isNegative ? PdfColors.red700 : PdfColors.blue700;

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        theme: pw.ThemeData.withFont(
          base: font, 
          bold: fontBold,
        ),
        build: (pw.Context context) {
          return [
            // HEADER
            pw.Header(
              level: 0,
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    "Laporan Keuangan", 
                    style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)
                  ),
                  pw.SizedBox(height: 4),
                  pw.Text("Periode: ${report.meta.period}"),
                  pw.Divider(),
                ],
              ),
            ),

            // RINGKASAN
            pw.Container(
              margin: const pw.EdgeInsets.symmetric(vertical: 10),
              padding: const pw.EdgeInsets.all(10),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: PdfColors.grey),
                borderRadius: pw.BorderRadius.circular(4),
              ),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                children: [
                  _buildSummaryItem("Pemasukan", report.meta.totalIncome, currencyFormat, PdfColors.green700),
                  _buildSummaryItem("Pengeluaran", report.meta.totalExpense, currencyFormat, PdfColors.orange700),
                  // Gunakan warna dinamis di sini
                  _buildSummaryItem("Saldo Akhir", report.meta.netBalance, currencyFormat, balanceColor),
                ],
              ),
            ),

            pw.SizedBox(height: 20),
            pw.Text("Rincian Transaksi:", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14)),
            pw.SizedBox(height: 10),

            // TABEL TRANSAKSI
            pw.Table.fromTextArray(
              border: pw.TableBorder.all(color: PdfColors.grey300),
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white),
              headerDecoration: const pw.BoxDecoration(color: PdfColors.blueGrey700),
              cellHeight: 25,
              cellAlignments: {
                0: pw.Alignment.centerLeft,
                1: pw.Alignment.centerLeft,
                2: pw.Alignment.centerLeft,
                3: pw.Alignment.center,
                4: pw.Alignment.centerRight,
              },
              headers: ['Tanggal', 'Kategori', 'Ket', 'Tipe', 'Jumlah'],
              data: report.data.map((item) {
                return [
                  item.date,
                  item.categoryName,
                  item.title,
                  item.type == 'income' ? 'Masuk' : 'Keluar',
                  currencyFormat.format(item.amount),
                ];
              }).toList(),
            ),
          ];
        },
      ),
    );

    // FUNGSI INI AMAN JIKA DIBUKA DI TAB BARU
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => doc.save(),
      name: 'Laporan_Keuangan_${report.meta.period}',
    );
  }

  static pw.Widget _buildSummaryItem(String label, double value, NumberFormat fmt, PdfColor color) {
    return pw.Column(
      children: [
        pw.Text(label, style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700)),
        pw.Text(
          fmt.format(value), 
          style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold, color: color)
        ),
      ]
    );
  }
} 