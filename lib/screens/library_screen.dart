import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/cd_model.dart';
import '../services/firestore_service.dart';
import 'search_screen.dart'; // Importar la nueva pantalla de búsqueda

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
          // Añadir un botón de búsqueda a la AppBar
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
                  leading: cd.coverUrl.isNotEmpty
                      ? Image.network(cd.coverUrl, width: 50, height: 50, fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => const Icon(Icons.album, size: 50),)
                      : const Icon(Icons.album, size: 50),
                  title: Text(cd.title),
                  subtitle: Text(cd.artist),
                  // Añadimos un botón de borrado al final de cada elemento
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline),
                    tooltip: 'Delete from Library',
                    onPressed: () {
                      // Llamamos a la función de borrado con el ID del documento
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