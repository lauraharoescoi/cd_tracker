import 'package:flutter/material.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Wishlist'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: const Center(
        child: Text(
          'CDs you want to buy will appear here.',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
