import 'package:flutter/material.dart';
import 'catalogo_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prime Lab'),
        actions: [
          IconButton(
            icon: const Icon(Icons.storefront),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const CatalogoPage()),
              ),
            ),
            ],
      ),
      body: const Center(
        child: Text('Benvenuto in Prime Lab!'),
      ),
    );
  }
}
