import 'dart:typed_data';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../data/models/finance_report_model.dart';

class PdfGenerator {
  
  // Fungsi utama untuk generate PDF
  static Future<void> generateAndShow(FinanceReportModel report) async {
    final pdf = pw.Document();

    // Tambahkan Halaman
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return [
            _buildHeader(report),
            pw.SizedBox(height: 20),
            _buildSummary(report),
            pw.SizedBox(height: 20),
            _buildTable(report),
            pw.SizedBox(height: 20),
            _buildFooter(),
          ];
        },
      ),
    );

    // Tampilkan Preview / Share
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  // --- KOMPONEN PDF ---

  static pw.Widget _buildHeader(FinanceReportModel report) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text('Laporan Keuangan', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
        pw.Text('Jawara Pintar', style: const pw.TextStyle(fontSize: 14, color: PdfColors.grey700)),
        pw.SizedBox(height: 10),
        pw.Text('Periode: ${report.meta.period}', style: const pw.TextStyle(fontSize: 12)),
      ],
    );
  }

  static pw.Widget _buildSummary(FinanceReportModel report) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey),
        borderRadius: pw.BorderRadius.circular(4),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          _summaryItem("Total Pemasukan", report.meta.totalIncome, PdfColors.green),
          _summaryItem("Total Pengeluaran", report.meta.totalExpense, PdfColors.red),
          _summaryItem("Saldo Bersih", report.meta.netBalance, PdfColors.blue),
        ],
      ),
    );
  }

  static pw.Widget _summaryItem(String label, double value, PdfColor color) {
    final formatCurrency = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(label, style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey600)),
        pw.Text(formatCurrency.format(value), style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold, color: color)),
      ],
    );
  }

  static pw.Widget _buildTable(FinanceReportModel report) {
    final formatCurrency = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    // Header Table
    final headers = ['Tanggal', 'Kategori', 'Keterangan', 'Jumlah'];

    // Data Table
    final data = report.data.map((item) {
      return [
        item.date,
        item.categoryName,
        item.title,
        formatCurrency.format(item.amount),
      ];
    }).toList();

    return pw.TableHelper.fromTextArray(
      headers: headers,
      data: data,
      border: null,
      headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
      headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
      cellHeight: 30,
      cellAlignments: {
        0: pw.Alignment.centerLeft,
        1: pw.Alignment.centerLeft,
        2: pw.Alignment.centerLeft,
        3: pw.Alignment.centerRight,
      },
    );
  }

  static pw.Widget _buildFooter() {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Divider(),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text("Dicetak otomatis oleh Sistem Jawara Pintar", style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey)),
            pw.Text(DateFormat('dd MMM yyyy HH:mm').format(DateTime.now()), style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey)),
          ],
        )
      ],
    );
  }
}