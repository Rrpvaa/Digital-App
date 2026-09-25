import 'package:flutter/material.dart';
import '../helpers/db_helper.dart';

class CartProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _cartItems = [];

  List<Map<String, dynamic>> get cartItems => _cartItems;

  Future<void> loadCart() async {
    _cartItems = await DBHelper.getCart();
    notifyListeners();
  }

  Future<void> addToCart(
    int productId,
    String name,
    double price,
  ) async {
    await DBHelper.addToCart(
      productId,
      name,
      price,
    );

    await loadCart();
  }

  Future<void> increaseQuantity(int cartId) async {
    await DBHelper.increaseQuantity(cartId);
    await loadCart();
  }

  Future<void> decreaseQuantity(int cartId) async {
    await DBHelper.decreaseQuantity(cartId);
    await loadCart();
  }

  Future<void> removeFromCart(int cartId) async {
    await DBHelper.removeFromCart(cartId);
    await loadCart();
  }

  double get totalPrice {
    double total = 0;

    for (var item in _cartItems) {
      final double price =
          (item['price'] as num).toDouble();

      final int quantity =
          item['quantity'] as int;

      total += price * quantity;
    }

    return total;
  }
}