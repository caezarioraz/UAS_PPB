import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uas_ppb/screens/update_page_screen.dart';
import 'package:uas_ppb/utils/product_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../services/api_service.dart';
import '../widgets/product_card.dart';
import '../models/product.dart';
import '../screens/product_detail_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String? _role;

  @override
  void initState() {
    super.initState();
    _loadUserRole();
    Provider.of<ProductProvider>(context, listen: false).fetchProducts();
  }

  Future<void> _loadUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _role = prefs.getString('role');
    });
  }

  Future<bool> _checkInternetConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult != ConnectivityResult.none;
  }

  Future<void> _openWhatsApp(String phone, {String message = ''}) async {
    try {
      phone = phone.replaceAll(RegExp(r'[^\d]'), '');
      String url = "https://wa.me/$phone/?text=${Uri.encodeComponent(message)}";
      final Uri whatsappUri = Uri.parse(url);

      if (await canLaunchUrl(whatsappUri)) {
        await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
      } else {
        final fallbackUrl = "https://wa.me/$phone";
        await launchUrl(Uri.parse(fallbackUrl), mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      _showErrorDialog(context, 'Error: ${e.toString()}');
    }
  }

  Future<void> _openMaps() async {
    try {
      final String googleMapsUrl = 'https://www.google.com/maps/search/restaurants+near+me';
      final Uri mapsUri = Uri.parse(googleMapsUrl);

      if (await canLaunchUrl(mapsUri)) {
        await launchUrl(mapsUri, mode: LaunchMode.externalApplication);
      } else {
        final fallbackUrl = 'https://www.google.com/maps/search/restaurants+near+me';
        await launchUrl(Uri.parse(fallbackUrl), mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      _showErrorDialog(context, 'Error: ${e.toString()}');
    }
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushReplacementNamed(context, '/login');
  }

  void _navigateToUpdateUser() async {
    final prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt('user_id') ?? 0;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UpdateUserScreen(userId: userId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87, // Tema gelap
      appBar: AppBar(
        title: const Text('Dashboard Produk'),
        backgroundColor: Colors.blueAccent, // Warna biru di app bar
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.pushNamed(context, '/cart');
            },
          ),
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.pushNamed(context, '/purchaseHistory');
            },
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _navigateToUpdateUser,
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: Consumer<ProductProvider>(
        builder: (context, productProvider, child) {
          final products = productProvider.products;
          if (products.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return ProductCard(
                  name: product.name,
                  description: product.description,
                  price: product.price.toString(),
                  imageUrl: product.imageUrl,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetailScreen(
                          productId: product.id,
                        ),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
      floatingActionButton: _role == 'admin'
          ? Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(context, '/adminPanel');
            },
            child: const Icon(Icons.admin_panel_settings),
            heroTag: "adminPanelButton",
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(context, '/adminProducts');
            },
            child: const Icon(Icons.add),
            heroTag: "adminProductsButton",
          ),
        ],
      )
          : null,
      bottomNavigationBar: BottomAppBar(
        color: Colors.black87, // BottomAppBar dengan latar belakang gelap
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.phone, color: Colors.white),
              onPressed: () {
                String phone = '+628123456789'; // Nomor WhatsApp
                _openWhatsApp(phone, message: 'Halo, ada pertanyaan mengenai produk!');
              },
            ),
            IconButton(
              icon: const Icon(Icons.message, color: Colors.white),
              onPressed: () {
                String phone = '+628123456789'; // Nomor WhatsApp
                _openWhatsApp(phone, message: 'Halo, saya ingin bertanya!');
              },
            ),
            IconButton(
              icon: const Icon(Icons.map, color: Colors.white),
              onPressed: _openMaps,
            ),
          ],
        ),
      ),
    );
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error', style: TextStyle(color: Colors.red)),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}