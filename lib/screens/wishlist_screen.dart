import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/cd_model.dart';
import '../services/firestore_service.dart';
import 'album_detail_screen.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  final FirestoreService _firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Wishlist'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestoreService.getWishlistStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<CD> wishlist = snapshot.data!.docs.map((doc) => CD.fromFirestore(doc)).toList();

            if (wishlist.isEmpty) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Your wishlist is empty. Find an album to add!',
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }

            return ListView.builder(
              itemCount: wishlist.length,
              itemBuilder: (context, index) {
                CD cd = wishlist[index];
                return ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AlbumDetailScreen(
                          cd: cd,
                          // Le decimos a la pantalla de detalle que venimos de la wishlist
                          sourceCollection: 'wishlist',
                        ),
                      ),
                    );
                  },
                  leading: cd.coverUrl.isNotEmpty
                      ? Image.network(cd.coverUrl, width: 50, height: 50, fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => const Icon(Icons.album, size: 50),)
                      : const Icon(Icons.album, size: 50),
                  title: Text(cd.title),
                  subtitle: Text(cd.artist),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.shopping_cart_checkout),
                        tooltip: 'Move to Library',
                        onPressed: () {
                          _firestoreService.moveCDFromWishlistToLibrary(cd);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('${cd.title} moved to your library!')),
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return const Center(child: Text("Something went wrong."));
          }
        },
      ),
    );
  }
}