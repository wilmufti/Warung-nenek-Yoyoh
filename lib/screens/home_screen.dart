import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/product.dart';
import 'detail_screen.dart';
import 'cart_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // --- DATA LOKAL (DUMMY DATA) ---
  final List<Product> _products = [
    Product(id: 1, nama: "Indomie", harga: 3500, gambarProduk: "assets/images/Indomie.png", deskripsi: "Indomie adalah mie instan favorit masyarakat Indonesia dengan berbagai varian rasa yang lezat dan mudah disiapkan untuk sajian cepat dan praktis."),
    Product(id: 2, nama: "Sunlight", harga: 5000, gambarProduk: "assets/images/Sunlight.png", deskripsi: "Sunlight adalah sabun pencuci piring dengan formula aktif penghilang lemak, membuat peralatan makan bersih, higienis, dan harum."),
    Product(id: 3, nama: "Minyakita", harga: 36000, gambarProduk: "assets/images/minyak.png", deskripsi: "Minyakita adalah minyak goreng kemasan bersubsidi yang jernih, sehat, terjangkau, dan cocok digunakan untuk menggoreng maupun menumis."),
    Product(id: 4, nama: "Beras 5kg", harga: 68000, gambarProduk: "assets/images/Beras.png", deskripsi: "Beras 5 kg adalah bahan pangan pokok yang bergizi, pulen, wangi, dan mudah dimasak untuk memenuhi kebutuhan konsumsi rumah tangga."),
    Product(id: 5, nama: "Gas LPG 3kg", harga: 20000, gambarProduk: "assets/images/Gas.png", deskripsi: "Gas LPG 3 kg adalah bahan bakar memasak bersubsidi yang ringan, praktis, hemat, dan mudah digunakan untuk kebutuhan rumah tangga sehari-hari."),
    Product(id: 6, nama: "Mie Sedaap", harga: 3000, gambarProduk: "assets/images/miesedaap.png", deskripsi: "Mie Sedaap menawarkan rasa gurih dan kenyal yang nikmat, cocok untuk disantap kapan saja sebagai pilihan mie instan berkualitas."),
  ];

  @override
  Widget build(BuildContext context) {
    final formatCurrency = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0);

    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: (index) {
          if (index == 2) { // Index 2 adalah ikon keranjang
            Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const CartScreen()));
          }
          // Anda bisa menambahkan navigasi untuk search (index 1) nanti
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart_outlined), label: 'Cart'),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Teks Judul "Menu"
                const Text('Menu', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),

                // 2. Kotak Pencarian
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const TextField(
                    decoration: InputDecoration(
                      icon: Icon(Icons.search, color: Colors.grey),
                      hintText: 'Mencari barang',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // 3. Daftar Kategori
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CategoryItem(icon: '📦', label: 'All', isActive: true),
                    CategoryItem(icon: '🌾', label: 'Beras'),
                    CategoryItem(icon: '🧴', label: 'Minyak'),
                    CategoryItem(icon: '🍜', label: 'Vetsin'),
                  ],
                ),
                const SizedBox(height: 24),

                // 4. Banner Promosi
                Container(
                  height: 120,
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEDE7F6),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Promotions', style: TextStyle(color: Colors.black54)),
                      SizedBox(height: 8),
                      Text('Free box of Eggs', style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // 5. Teks "Popular"
                const Text('Popular', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),

                // 6. Grid Produk
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.7,
                  ),
                  itemCount: _products.length,
                  itemBuilder: (context, index) {
                    final product = _products[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (ctx) => DetailScreen(product: product)),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Center(
                                child: Image.asset(
                                  product.gambarProduk,
                                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.image_not_supported),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(product.nama, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            const SizedBox(height: 4),
                            Text(
                              formatCurrency.format(product.harga),
                              style: TextStyle(color: Colors.grey[700], fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ---- WIDGET UNTUK ITEM KATEGORI ----
class CategoryItem extends StatelessWidget {
  final String icon;
  final String label;
  final bool isActive;
  const CategoryItem({super.key, required this.icon, required this.label, this.isActive = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            color: isActive ? Colors.deepPurple : Colors.grey[200],
            borderRadius: BorderRadius.circular(16),
          ),
          child: Center(
            child: Text(
              icon,
              style: TextStyle(fontSize: 28, color: isActive ? Colors.white : Colors.black),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
      ],
    );
  }
}