import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';
import 'detail_screen.dart';
import 'cart_screen.dart';
import 'pencarian_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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

  // --- KATEGORI ---
  String _selectedCategory = 'All';

  void _selectCategory(String category) {
    setState(() {
      _selectedCategory = category;
    });
  }

  @override
  Widget build(BuildContext context) {
    final formatCurrency = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    );

    // --- FILTER PRODUK BERDASARKAN KATEGORI ---
    final filteredProducts = _selectedCategory == 'All'
        ? _products
        : _products
            .where((p) =>
                p.kategori.toLowerCase() ==
                _selectedCategory.toLowerCase())
            .toList();

    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: (index) {
          if (index == 1) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (ctx) => const PencarianScreen(),
              ),
            );
          }
          if (index == 2) {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (ctx) => const CartScreen()),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined),
            label: 'Cart',
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Menu',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),

                // Search bar
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (ctx) => const PencarianScreen(),
                      ),
                    );
                  },
                  child: AbsorbPointer(
                    child: TextField(
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Colors.grey,
                        ),
                        hintText: 'Mencari barang',
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // --- KATEGORI ---
                SizedBox(
                  height: 95,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      CategoryItem(
                        icon: '📦',
                        label: 'Semua',
                        isActive: _selectedCategory == 'All',
                        onTap: () => _selectCategory('All'),
                      ),
                      const SizedBox(width: 16),
                      CategoryItem(
                        icon: '🌾',
                        label: 'Beras',
                        isActive: _selectedCategory == 'Beras',
                        onTap: () => _selectCategory('Beras'),
                      ),
                      const SizedBox(width: 16),
                      CategoryItem(
                        icon: '🧴',
                        label: 'Minyak',
                        isActive: _selectedCategory == 'Minyak',
                        onTap: () => _selectCategory('Minyak'),
                      ),
                      const SizedBox(width: 16),
                      CategoryItem(
                        icon: '🍜',
                        label: 'Mie',
                        isActive: _selectedCategory == 'Mie',
                        onTap: () => _selectCategory('Mie'),
                      ),
                    ],
                  ),
                ),

                const Text(
                  'Popular',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),

                // --- PRODUK (SESUAI KATEGORI) ---
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.7,
                  ),
                  itemCount: filteredProducts.length,
                  itemBuilder: (context, index) {
                    final product = filteredProducts[index];
                    return GestureDetector(
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (ctx) => DetailScreen(product: product),
                        ),
                      ),
                      child: Stack(
                        children: [
                          Container(
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
                                    child: Image.asset(product.gambarProduk),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  product.nama,
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

                          // Tombol tambah ke keranjang
                          Positioned(
                            bottom: 8,
                            right: 8,
                            child: IconButton(
                              style: IconButton.styleFrom(
                                backgroundColor: Colors.deepPurple,
                                foregroundColor: Colors.white,
                              ),
                              icon: const Icon(Icons.add),
                              onPressed: () async {
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

                                if (confirm == true) {
                                  Provider.of<CartProvider>(
                                    context,
                                    listen: false,
                                  ).addItem(product);

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content:
                                          Text('${product.nama} ditambahkan'),
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
    );
  }
}

// Widget kategori
class CategoryItem extends StatelessWidget {
  final String icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const CategoryItem({
    super.key,
    required this.icon,
    required this.label,
    this.isActive = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Column(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: isActive ? Colors.deepPurple : Colors.grey[200],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Text(
                    icon,
                    style: TextStyle(
                      fontSize: 28,
                      color: isActive ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }
}
