import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uas_ppb/services/api_service.dart';
import 'package:uas_ppb/models/product.dart';
import 'package:uas_ppb/utils/product_provider.dart';
import 'edit_product_screen.dart'; // Import halaman edit produk
import 'add_product_screen.dart'; // Import halaman tambah produk

class AdminProductScreen extends StatefulWidget {
  const AdminProductScreen({super.key});

  @override
  State<AdminProductScreen> createState() => _AdminProductScreenState();
}

class _AdminProductScreenState extends State<AdminProductScreen> {
  late Future<List<Product>> _products;

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    await Provider.of<ProductProvider>(context, listen: false).fetchProducts();
  }

  Future<void> _deleteProduct(int productId) async {
    try {
      await Provider.of<ProductProvider>(context, listen: false)
          .deleteProduct(productId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Produk berhasil dihapus')),
      );
      _fetchProducts(); // Refresh the product list
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menghapus produk: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87, // Background gelap untuk tema gelap
      appBar: AppBar(
        title: const Text('Admin Produk'),
        backgroundColor: Colors.blueAccent, // Warna biru yang lebih terang pada app bar
      ),
      body: Consumer<ProductProvider>(
        builder: (context, productProvider, child) {
          final products = productProvider.products;
          if (products.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return Card(
                  color: Colors.grey[850], // Card dengan warna gelap
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(
                      product.name,
                      style: TextStyle(color: Colors.white), // Teks putih
                    ),
                    subtitle: Text(
                      '\$${product.price}',
                      style: TextStyle(color: Colors.white70), // Teks harga dengan warna lebih terang
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.white), // Ikon edit putih
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditProductScreen(product: product),
                              ),
                            ).then((_) => _fetchProducts()); // Refresh after editing
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red), // Ikon hapus merah
                          onPressed: () {
                            _deleteProduct(product.id);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent, // Tombol aksi dengan warna biru cerah
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddProductScreen(), // Navigasi ke halaman tambah produk
            ),
          ).then((_) => _fetchProducts()); // Refresh after adding
        },
        child: const Icon(Icons.add, color: Colors.white), // Ikon tambah produk putih
      ),
    );
  }
}
