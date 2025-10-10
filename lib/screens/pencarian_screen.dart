import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';
import 'detail_screen.dart';

class PencarianScreen extends StatefulWidget {
  const PencarianScreen({super.key});

  @override
  State<PencarianScreen> createState() => _PencarianScreenState();
}

class _PencarianScreenState extends State<PencarianScreen> {
  // --- DATA LOKAL (DUMMY DATA) ---
  final List<Product> _products = [
    Product(
      id: 1,
      nama: "Indomie",
      harga: 3500,
      gambarProduk: "assets/images/Indomie.png",
      deskripsi: "Indomie adalah mie instan favorit masyarakat Indonesia.",
      kategori: 'Mie',
    ),
    Product(
      id: 2,
      nama: "Sunlight",
      harga: 5000,
      gambarProduk: "assets/images/Sunlight.png",
      deskripsi: "Sunlight adalah sabun pencuci piring.",
      kategori: 'Sabun',
    ),
    Product(
      id: 3,
      nama: "Minyakita",
      harga: 36000,
      gambarProduk: "assets/images/minyak.png",
      deskripsi: "Minyakita adalah minyak goreng kemasan.",
      kategori: 'Minyak',
    ),
    Product(
      id: 4,
      nama: "Beras 5kg",
      harga: 68000,
      gambarProduk: "assets/images/Beras.png",
      deskripsi: "Beras 5 kg adalah bahan pangan pokok.",
      kategori: 'Beras',
    ),
    Product(
      id: 5,
      nama: "Gas LPG 3kg",
      harga: 20000,
      gambarProduk: "assets/images/Gas.png",
      deskripsi: "Gas LPG 3 kg adalah bahan bakar memasak.",
      kategori: 'Gas',
    ),
    Product(
      id: 6,
      nama: "Mie Sedaap",
      harga: 3000,
      gambarProduk: "assets/images/miesedaap.png",
      deskripsi: "Mie Sedaap menawarkan rasa gurih dan kenyal.",
      kategori: 'Mie',
    ),
  ];

  String _searchQuery = '';
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // Otomatis fokus ke kolom pencarian saat halaman dibuka
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _searchFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _searchFocusNode.dispose();
    super.dispose();
  }

  List<Product> get _filteredProducts {
    if (_searchQuery.isEmpty) return _products;
    return _products
        .where((p) => p.nama.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final formatCurrency = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    );

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text(
            'Pencarian Barang',
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.black),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- Kolom Pencarian ---
                  TextField(
                    focusNode: _searchFocusNode,
                    onChanged: (value) => setState(() => _searchQuery = value),
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search, color: Colors.grey),
                      hintText: 'Mencari barang...',
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 16,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  const Text(
                    'Hasil Pencarian',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),

                  // --- Grid Produk ---
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _filteredProducts.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 0.7,
                        ),
                    itemBuilder: (context, index) {
                      final product = _filteredProducts[index];
                      return GestureDetector(
                        onTap: () {
                          FocusScope.of(context).unfocus();
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (ctx) => DetailScreen(product: product),
                            ),
                          );
                        },
                        child: Stack(
                          children: [
                            // --- Kartu Produk ---
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.05),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Center(
                                      child: Image.asset(
                                        product.gambarProduk,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    product.nama,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    formatCurrency.format(product.harga),
                                    style: TextStyle(
                                      color: Colors.grey[700],
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // --- Tombol Tambah ke Keranjang ---
                            Positioned(
                              bottom: 8,
                              right: 8,
                              child: IconButton.filled(
                                style: IconButton.styleFrom(
                                  backgroundColor: Colors.deepPurple,
                                  foregroundColor: Colors.white,
                                ),
                                icon: const Icon(Icons.add),
                                onPressed: () async {
                                  if (product.nama.isEmpty ||
                                      product.harga == 0) {
                                    // Produk tidak valid
                                    if (!context.mounted) return;
                                    await showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: const Text('Produk Tidak Valid'),
                                        content: const Text(
                                          'Produk ini tidak dapat ditambahkan ke keranjang.',
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            child: const Text('OK'),
                                          ),
                                        ],
                                      ),
                                    );
                                    return;
                                  }

                                  // Konfirmasi tambah produk
                                  if (!context.mounted) return;
                                  final confirm = await showDialog<bool>(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text('Konfirmasi'),
                                        content: Text(
                                          'Tambahkan "${product.nama}" ke keranjang?',
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context, false),
                                            child: const Text('Batal'),
                                          ),
                                          ElevatedButton(
                                            onPressed: () =>
                                                Navigator.pop(context, true),
                                            child: const Text('Ya'),
                                          ),
                                        ],
                                      );
                                    },
                                  );

                                  if (confirm == true && context.mounted) {
                                    Provider.of<CartProvider>(
                                      context,
                                      listen: false,
                                    ).addItem(product);

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          '${product.nama} berhasil ditambahkan!',
                                        ),
                                        duration: const Duration(seconds: 1),
                                      ),
                                    );
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
