class Product {
  final int id;
  final String nama;
  final int harga;
  final String gambarProduk;
  final String deskripsi;
  final String kategori; // Tambahkan kategori untuk filtering

  Product({
    required this.id,
    required this.nama,
    required this.harga,
    required this.gambarProduk,
    required this.deskripsi,
    this.kategori = 'Lainnya', // Default kategori
  });
}