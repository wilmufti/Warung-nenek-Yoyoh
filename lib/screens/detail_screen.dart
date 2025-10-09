import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';

class DetailScreen extends StatelessWidget {
  final Product product;
  const DetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0, foregroundColor: Colors.black),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(child: Image.asset(product.gambarProduk, height: 250)),
                    const SizedBox(height: 24),
                    Text(product.nama, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text('Rp${product.harga}', style: const TextStyle(fontSize: 22, color: Colors.deepPurple, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 16),
                    Text(product.deskripsi, style: TextStyle(fontSize: 16, color: Colors.grey[700], height: 1.5)),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
              ),
              onPressed: () {
                Provider.of<CartProvider>(context, listen: false).addItem(product);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${product.nama} ditambahkan'), duration: const Duration(seconds: 1)));
              },
              child: const Text('Add to Cart', style: TextStyle(fontSize: 18)),
            ),
          ),
        ],
      ),
    );
  }
}