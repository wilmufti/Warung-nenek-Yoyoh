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
      appBar: AppBar(title: Text(product.nama)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(product.gambarProduk, height: 300, fit: BoxFit.contain),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.nama, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  Text('Rp${product.harga}', style: const TextStyle(fontSize: 20, color: Colors.deepPurple)),
                  const SizedBox(height: 10),
                  Text(product.deskripsi, style: const TextStyle(fontSize: 16)),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(15)),
          onPressed: () {
            Provider.of<CartProvider>(context, listen: false).addItem(product);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('${product.nama} ditambahkan ke keranjang!'), duration: const Duration(seconds: 1)),
            );
          },
          child: const Text('Add to Cart', style: TextStyle(fontSize: 18)),
        ),
      ),
    );
  }
}