import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  String formatPrice(double price) {
    return 'Rp ${price.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'\B(?=(\d{3})+(?!\d))'),
          (match) => '.',
        )}';
  }

  String getProductImage(String productId, String name) {
    switch (productId) {
      case '1':
        return 'assets/images/baju1.jpg';

      case '2':
        return 'assets/images/baju2.jpg';

      case '3':
        return 'assets/images/jeans.jpg';

      case '4':
        return 'assets/images/sepatu.jpg';

      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF9F5F5),

      // =========================
      // APP BAR
      // =========================
      appBar: AppBar(
        backgroundColor: const Color(0xFF800000),
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,

        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),

        title: const Text(
          'Keranjang Belanja',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: cart.cartItems.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 90,
                    color: Color(0xFF800000),
                  ),
                  SizedBox(height: 15),
                  Text(
                    'Keranjang masih kosong',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF3D2730),
                    ),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                // =========================
                // LIST KERANJANG
                // =========================
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(18),
                    itemCount: cart.cartItems.length,
                    itemBuilder: (context, index) {
                      final item = cart.cartItems[index];

                      final int cartId = item['id'] as int;

                      final String name =
                          item['name'].toString();

                      final double price =
                          (item['price'] as num).toDouble();

                      final int quantity =
                          item['quantity'] as int;

                      final String image =
                          getProductImage(
                        item['product_id'].toString(),
                        name,
                      );

                      return Container(
                        margin: const EdgeInsets.only(
                          bottom: 15,
                        ),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.circular(22),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            // =========================
                            // GAMBAR
                            // =========================
                            Container(
                              width: 105,
                              height: 120,
                              decoration: BoxDecoration(
                                color: const Color(0xFFF8F4F4),
                                borderRadius:
                                    BorderRadius.circular(17),
                              ),
                              child: image.isEmpty
                                  ? const Icon(
                                      Icons.shopping_bag_outlined,
                                      size: 50,
                                      color: Color(0xFF800000),
                                    )
                                  : Padding(
                                      padding:
                                          const EdgeInsets.all(8),
                                      child: Image.asset(
                                        image,
                                        fit: BoxFit.contain,
                                        errorBuilder:
                                            (context, error,
                                                stackTrace) {
                                          return const Icon(
                                            Icons
                                                .shopping_bag_outlined,
                                            size: 50,
                                            color:
                                                Color(0xFF800000),
                                          );
                                        },
                                      ),
                                    ),
                            ),

                            const SizedBox(width: 15),

                            // =========================
                            // DETAIL
                            // =========================
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    name,
                                    maxLines: 2,
                                    overflow:
                                        TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight:
                                          FontWeight.bold,
                                      color:
                                          Color(0xFF3D2730),
                                    ),
                                  ),

                                  const SizedBox(height: 8),

                                  Text(
                                    formatPrice(price),
                                    style: const TextStyle(
                                      color:
                                          Color(0xFF800000),
                                      fontSize: 15,
                                      fontWeight:
                                          FontWeight.bold,
                                    ),
                                  ),

                                  const SizedBox(height: 15),

                                  // =========================
                                  // + DAN -
                                  // =========================
                                  Row(
                                    children: [
                                      _quantityButton(
                                        icon: Icons.remove,
                                        onPressed: () {
                                          cart.decreaseQuantity(
                                            cartId,
                                          );
                                        },
                                      ),

                                      SizedBox(
                                        width: 42,
                                        child: Center(
                                          child: Text(
                                            '$quantity',
                                            style:
                                                const TextStyle(
                                              fontSize: 16,
                                              fontWeight:
                                                  FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),

                                      _quantityButton(
                                        icon: Icons.add,
                                        onPressed: () {
                                          cart.increaseQuantity(
                                            cartId,
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            // =========================
                            // DELETE
                            // =========================
                            IconButton(
                              onPressed: () {
                                cart.removeFromCart(cartId);
                              },
                              icon: const Icon(
                                Icons.delete_outline,
                                color: Colors.grey,
                                size: 28,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                // =========================
                // TOTAL
                // =========================
                Container(
                  padding: const EdgeInsets.fromLTRB(
                    25,
                    20,
                    25,
                    25,
                  ),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total Belanja',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF3D2730),
                            ),
                          ),

                          Text(
                            formatPrice(cart.totalPrice),
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF800000),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 18),

                      // =========================
                      // CHECKOUT
                      // =========================
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Fitur checkout belum tersedia',
                                ),
                                backgroundColor:
                                    Color(0xFF800000),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color(0xFF800000),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(17),
                            ),
                          ),
                          child: const Text(
                            'Checkout',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _quantityButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: 42,
      height: 42,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.zero,
          side: const BorderSide(
            color: Color(0xFF800000),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Icon(
          icon,
          color: const Color(0xFF800000),
        ),
      ),
    );
  }
}