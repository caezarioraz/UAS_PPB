import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PaymentPage extends StatefulWidget {
  final double totalPrice;
  final double shippingCost;

  const PaymentPage({Key? key, required this.totalPrice, required this.shippingCost}) : super(key: key);

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final TextEditingController _amountController = TextEditingController();
  double? _totalPayment;

  @override
  void initState() {
    super.initState();
    _totalPayment = widget.totalPrice + widget.shippingCost;
  }

  Future<void> _generatePdf() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                pw.Text('Nota Pembayaran', style: pw.TextStyle(fontSize: 24)),
                pw.SizedBox(height: 20),
                pw.Text('Total Harga: Rp ${widget.totalPrice}'),
                pw.Text('Ongkir: Rp ${widget.shippingCost}'),
                pw.Text('Total Pembayaran: Rp $_totalPayment'),
              ],
            ),
          );
        },
      ),
    );

    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pembayaran'),
        backgroundColor: Colors.blueAccent, // Blue theme for the AppBar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Total Pembayaran: Rp $_totalPayment',
              style: const TextStyle(fontSize: 20, color: Colors.white), // White text color
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Masukkan Total Harga',
                labelStyle: const TextStyle(color: Colors.blueAccent), // Blue label
                filled: true,
                fillColor: Colors.black.withOpacity(0.7), // Dark background for text field
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide(color: Colors.blueAccent), // Blue border
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide(color: Colors.blueAccent),
                ),
              ),
              style: const TextStyle(color: Colors.white), // White text color
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _generatePdf(); // Generate PDF when pressed
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent, // Blue button
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text(
                'Bayar',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white), // White text on button
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.black, // Black background for the whole page
    );
  }
}
