import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';
import 'cart_page.dart';

class CatalogPage extends StatefulWidget {
  const CatalogPage({super.key});

  @override
  State<CatalogPage> createState() => _CatalogPageState();
}

class _CatalogPageState extends State<CatalogPage> {
  final TextEditingController searchController = TextEditingController();

  int selectedMenu = 0;

  final List<Map<String, dynamic>> products = [
    {
      'id': 1,
      'name': 'Striped Sweater',
      'price': 50000.0,
      'image': 'assets/images/baju1.jpg',
    },
    {
      'id': 2,
      'name': 'Kemeja Ribbed Slim Fit',
      'price': 65000.0,
      'image': 'assets/images/baju2.jpg',
    },
    {
      'id': 3,
      'name': 'Wide Leg Jeans',
      'price': 70000.0,
      'image': 'assets/images/jeans.jpg',
    },
    {
      'id': 4,
      'name': 'Brown Sneakers',
      'price': 98000.0,
      'image': 'assets/images/sepatu.jpg',
    },
  ];

  String searchText = '';

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  String formatPrice(double price) {
    return 'Rp ${price.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'\B(?=(\d{3})+(?!\d))'),
          (match) => '.',
        )}';
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    final filteredProducts = products.where((product) {
      final name = product['name'].toString().toLowerCase();

      return name.contains(searchText.toLowerCase());
    }).toList();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // =========================
            // HEADER
            // =========================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 25),
              decoration: const BoxDecoration(
                color: Color(0xFF800000),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  // Logo + Keranjang
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Digital App',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      // Icon keranjang
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const CartPage(),
                                ),
                              );
                            },
                            icon: const Icon(
                              Icons.shopping_cart_outlined,
                              color: Colors.white,
                              size: 32,
                            ),
                          ),

                          if (cart.cartItems.isNotEmpty)
                            Positioned(
                              right: 0,
                              top: -2,
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: Text(
                                  '${cart.cartItems.length}',
                                  style: const TextStyle(
                                    color: Color(0xFF800000),
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  // =========================
                  // SEARCH
                  // =========================
                  Container(
                    height: 58,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: TextField(
                      controller: searchController,
                      onChanged: (value) {
                        setState(() {
                          searchText = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Cari produk...',
                        hintStyle: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 16,
                        ),
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Color(0xFF800000),
                          size: 28,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 17,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // =========================
            // CONTENT
            // =========================
            Expanded(
              child: selectedMenu == 0
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(
                            24,
                            24,
                            24,
                            15,
                          ),
                          child: Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Produk Pilihan',
                                style: TextStyle(
                                  color: Color(0xFF3D2730),
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              Text(
                                '${filteredProducts.length} produk',
                                style: const TextStyle(
                                  color: Color(0xFF800000),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),

                        Expanded(
                          child: filteredProducts.isEmpty
                              ? const Center(
                                  child: Text(
                                    'Produk tidak ditemukan',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey,
                                    ),
                                  ),
                                )
                              : GridView.builder(
                                  padding: const EdgeInsets.fromLTRB(
                                    20,
                                    0,
                                    20,
                                    20,
                                  ),
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 14,
                                    mainAxisSpacing: 14,
                                    childAspectRatio: 0.68,
                                  ),
                                  itemCount: filteredProducts.length,
                                  itemBuilder: (context, index) {
                                    final product =
                                        filteredProducts[index];

                                    return _buildProductCard(
                                      context,
                                      product,
                                    );
                                  },
                                ),
                        ),
                      ],
                    )
                  : _buildPlaceholder(),
            ),

            // =========================
            // BOTTOM NAVIGATION
            // =========================
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 8,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _bottomItem(
                    icon: Icons.home_outlined,
                    activeIcon: Icons.home,
                    label: 'Beranda',
                    index: 0,
                  ),
                  _bottomItem(
                    icon: Icons.shopping_cart_outlined,
                    activeIcon: Icons.shopping_cart,
                    label: 'Keranjang',
                    index: 1,
                  ),
                  _bottomItem(
                    icon: Icons.person_outline,
                    activeIcon: Icons.person,
                    label: 'Profil',
                    index: 2,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductCard(
    BuildContext context,
    Map<String, dynamic> product,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // =========================
          // GAMBAR
          // =========================
          Expanded(
            flex: 5,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFF8F4F4),
                borderRadius: BorderRadius.circular(17),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Image.asset(
                  product['image'],
                  fit: BoxFit.contain,

                  // Kalau gambar belum ditemukan,
                  // aplikasi tetap menampilkan icon.
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.shopping_bag_outlined,
                      size: 70,
                      color: Color(0xFF800000),
                    );
                  },
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),

          // =========================
          // NAMA
          // =========================
          Text(
            product['name'],
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Color(0xFF3D2730),
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 7),

          // =========================
          // HARGA
          // =========================
          Text(
            formatPrice(product['price']),
            style: const TextStyle(
              color: Color(0xFF800000),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          // =========================
          // TOMBOL TAMBAH
          // =========================
          SizedBox(
            width: double.infinity,
            height: 43,
            child: ElevatedButton(
              onPressed: () async {
                await Provider.of<CartProvider>(
                  context,
                  listen: false,
                ).addToCart(
                  product['id'],
                  product['name'],
                  product['price'],
                );

                if (!context.mounted) return;

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      '${product['name']} ditambahkan ke keranjang',
                    ),
                    backgroundColor: const Color(0xFF800000),
                    duration: const Duration(seconds: 1),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF800000),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                '+ Tambah',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _bottomItem({
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required int index,
  }) {
    final bool active = selectedMenu == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedMenu = index;
        });

        if (index == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const CartPage(),
            ),
          );
        }
      },
      child: SizedBox(
        width: 85,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              active ? activeIcon : icon,
              color: active
                  ? const Color(0xFF800000)
                  : Colors.grey,
              size: 28,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: active
                    ? const Color(0xFF800000)
                    : Colors.grey,
                fontSize: 12,
                fontWeight:
                    active ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return const Center(
      child: Text(
        'Halaman Profil',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Color(0xFF3D2730),
        ),
      ),
    );
  }
}