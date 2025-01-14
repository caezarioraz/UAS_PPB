import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uas_ppb/utils/product_provider.dart';

class AddProductScreen extends StatelessWidget {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _imageUrlController = TextEditingController();

  void _addProduct(BuildContext context) async {
    final name = _nameController.text.trim();
    final description = _descriptionController.text.trim();
    final price = double.tryParse(_priceController.text.trim());
    final imageUrl = _imageUrlController.text.trim();

    if (name.isEmpty || description.isEmpty || price == null || imageUrl.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Harap isi semua kolom')),
      );
      return;
    }

    try {
      await Provider.of<ProductProvider>(context, listen: false)
          .addProduct(name, description, price, imageUrl);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Produk berhasil ditambahkan')),
      );
      Navigator.pop(context); // Kembali ke halaman sebelumnya
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menambahkan produk: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Produk'),
        backgroundColor: Colors.blueAccent, // Blue AppBar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Nama Produk',
                labelStyle: const TextStyle(color: Colors.blueAccent), // Blue label color
                filled: true,
                fillColor: Colors.black.withOpacity(0.7), // Dark background
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: const BorderSide(color: Colors.blueAccent), // Blue border
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: const BorderSide(color: Colors.blueAccent),
                ),
              ),
              style: const TextStyle(color: Colors.white), // White text
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Deskripsi',
                labelStyle: const TextStyle(color: Colors.blueAccent),
                filled: true,
                fillColor: Colors.black.withOpacity(0.7),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: const BorderSide(color: Colors.blueAccent),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: const BorderSide(color: Colors.blueAccent),
                ),
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _priceController,
              decoration: InputDecoration(
                labelText: 'Harga',
                labelStyle: const TextStyle(color: Colors.blueAccent),
                filled: true,
                fillColor: Colors.black.withOpacity(0.7),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: const BorderSide(color: Colors.blueAccent),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: const BorderSide(color: Colors.blueAccent),
                ),
              ),
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _imageUrlController,
              decoration: InputDecoration(
                labelText: 'URL Gambar',
                labelStyle: const TextStyle(color: Colors.blueAccent),
                filled: true,
                fillColor: Colors.black.withOpacity(0.7),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: const BorderSide(color: Colors.blueAccent),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: const BorderSide(color: Colors.blueAccent),
                ),
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => _addProduct(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent, // Blue button
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text(
                'Tambah Produk',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.black, // Black background for the page
    );
  }
}
