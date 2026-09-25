import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/cart_provider.dart';
import 'pages/catalog_page.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => CartProvider()..loadCart(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Digital App',

      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF800000),
        ),
        scaffoldBackgroundColor: const Color(0xFFF9F5F5),
        useMaterial3: true,
      ),

      home: const CatalogPage(),
    );
  }
}