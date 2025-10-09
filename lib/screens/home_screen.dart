import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';
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
      Product(id: 1, nama: "Indomie", harga: 3500, gambarProduk: "assets/images/Indomie.png", deskripsi: "Indomie adalah mie instan favorit masyarakat Indonesia.", kategori: 'Mie'),
      Product(id: 2, nama: "Sunlight", harga: 5000, gambarProduk: "assets/images/Sunlight.png", deskripsi: "Sunlight adalah sabun pencuci piring.", kategori: 'Sabun'),
      Product(id: 3, nama: "Minyakita", harga: 36000, gambarProduk: "assets/images/minyak.png", deskripsi: "Minyakita adalah minyak goreng kemasan.", kategori: 'Minyak'),
      Product(id: 4, nama: "Beras 5kg", harga: 68000, gambarProduk: "assets/images/Beras.png", deskripsi: "Beras 5 kg adalah bahan pangan pokok.", kategori: 'Beras'),
      Product(id: 5, nama: "Gas LPG 3kg", harga: 20000, gambarProduk: "assets/images/Gas.png", deskripsi: "Gas LPG 3 kg adalah bahan bakar memasak.", kategori: 'Gas'),
      Product(id: 6, nama: "Mie Sedaap", harga: 3000, gambarProduk: "assets/images/miesedaap.png", deskripsi: "Mie Sedaap menawarkan rasa gurih dan kenyal.", kategori: 'Mie'),
  ];
  
  // State untuk menyimpan input user
  String _searchQuery = '';
  String _selectedCategory = 'All';
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void dispose() {
    _searchFocusNode.dispose();
    super.dispose();
  }

  // Logika untuk memfilter produk
  List<Product> get _filteredProducts {
    List<Product> productsToFilter = List.from(_products);
    if (_selectedCategory != 'All') {
      productsToFilter = productsToFilter.where((p) => p.kategori == _selectedCategory).toList();
    }
    if (_searchQuery.isNotEmpty) {
      productsToFilter = productsToFilter.where((p) => p.nama.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
    }
    return productsToFilter;
  }

  // Fungsi untuk mengubah kategori terpilih
  void _selectCategory(String category) {
    setState(() {
      _selectedCategory = category;
    });
  }

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
          if (index == 1) {
            _searchFocusNode.requestFocus();
          }
          if (index == 2) {
            Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const CartScreen()));
          }
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
                const Text('Menu', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                TextField(
                  focusNode: _searchFocusNode,
                  onChanged: (value) => setState(() => _searchQuery = value),
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    hintText: 'Mencari barang',
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  ),
                ),
                const SizedBox(height: 24),
                
                SizedBox(
                  height: 110,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      CategoryItem(icon: '📦', label: 'All', isActive: _selectedCategory == 'All', onTap: () => _selectCategory('All')),
                      const SizedBox(width: 16),
                      CategoryItem(icon: '🌾', label: 'Beras', isActive: _selectedCategory == 'Beras', onTap: () => _selectCategory('Beras')),
                      const SizedBox(width: 16),
                      CategoryItem(icon: '🧴', label: 'Minyak', isActive: _selectedCategory == 'Minyak', onTap: () => _selectCategory('Minyak')),
                      const SizedBox(width: 16),
                      CategoryItem(icon: '🍜', label: 'Mie', isActive: _selectedCategory == 'Mie', onTap: () => _selectCategory('Mie')),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
               
                const SizedBox(height: 24),
                const Text('Popular', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.7,
                  ),
                  itemCount: _filteredProducts.length,
                  itemBuilder: (context, index) {
                    final product = _filteredProducts[index];
                    return GestureDetector(
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => DetailScreen(product: product))),
                      child: Stack(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(16)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(child: Center(child: Image.asset(product.gambarProduk))),
                                const SizedBox(height: 8),
                                Text(product.nama, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                const SizedBox(height: 4),
                                Text(formatCurrency.format(product.harga), style: TextStyle(color: Colors.grey[700], fontSize: 14)),
                              ],
                            ),
                          ),
                          Positioned(
                            bottom: 8,
                            right: 8,
                            child: IconButton(
                              style: IconButton.styleFrom(backgroundColor: Colors.deepPurple, foregroundColor: Colors.white),
                              icon: const Icon(Icons.add),
                              onPressed: () {
                                Provider.of<CartProvider>(context, listen: false).addItem(product);
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${product.nama} ditambahkan'), duration: const Duration(seconds: 1)));
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

// Widget terpisah untuk item kategori
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
          ),
        ),
      ),
    );
  }
}