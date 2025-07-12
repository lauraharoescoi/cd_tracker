import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/cd_model.dart';
import '../services/firestore_service.dart';
import 'album_detail_screen.dart'; // Importar la nueva pantalla
import 'search_screen.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  final FirestoreService _firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Library'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SearchScreen()),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestoreService.getLibraryStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<CD> cdList = snapshot.data!.docs.map((doc) => CD.fromFirestore(doc)).toList();

            if (cdList.isEmpty) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Your library is empty. Tap the search icon to find and add a CD!',
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }

            return ListView.builder(
              itemCount: cdList.length,
              itemBuilder: (context, index) {
                CD cd = cdList[index];
                return ListTile(
                  // NUEVO: Navegar a la pantalla de detalle al pulsar
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AlbumDetailScreen(cd: cd),
                      ),
                    );
                  },
                  leading: cd.coverUrl.isNotEmpty
                      ? Image.network(cd.coverUrl, width: 50, height: 50, fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => const Icon(Icons.album, size: 50),)
                      : const Icon(Icons.album, size: 50),
                  title: Text(cd.title),
                  subtitle: Text(cd.artist),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline),
                    tooltip: 'Delete from Library',
                    onPressed: () {
                      _firestoreService.deleteCDFromLibrary(cd.id);
                    },
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