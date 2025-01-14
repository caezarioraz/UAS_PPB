import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/product.dart';

class EditProductScreen extends StatefulWidget {
  final Product product;

  const EditProductScreen({super.key, required this.product});

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final ApiService _apiService = ApiService();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.product.name;
    _priceController.text = widget.product.price.toString();
    _descriptionController.text = widget.product.description;
  }

  Future<void> _updateProduct() async {
    final updatedProduct = Product(
      id: widget.product.id,
      name: _nameController.text,
      price: double.tryParse(_priceController.text) ?? 0.0,
      description: _descriptionController.text,
      imageUrl: widget.product.imageUrl, // Assuming imageUrl is not being changed
    );

    try {
      await _apiService.updateProduct(updatedProduct);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Produk berhasil diperbarui')),
      );
      Navigator.pop(context); // Kembali ke halaman sebelumnya
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memperbarui produk: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Produk'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Product Name Input
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Nama Produk',
                  labelStyle: TextStyle(color: Theme.of(context).colorScheme.secondary),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(color: Theme.of(context).dividerColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Product Price Input
              TextField(
                controller: _priceController,
                decoration: InputDecoration(
                  labelText: 'Harga Produk',
                  labelStyle: TextStyle(color: Theme.of(context).colorScheme.secondary),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(color: Theme.of(context).dividerColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary),
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),

              // Product Description Input
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Deskripsi Produk',
                  labelStyle: TextStyle(color: Theme.of(context).colorScheme.secondary),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(color: Theme.of(context).dividerColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary),
                  ),
                ),
                maxLines: 4,
              ),
              const SizedBox(height: 32),

              // Update Button
              ElevatedButton(
                onPressed: _updateProduct,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.secondary, // Button color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Perbarui Produk',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
