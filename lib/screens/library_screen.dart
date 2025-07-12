import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:reorderable_grid_view/reorderable_grid_view.dart';
import '../models/cd_model.dart';
import '../services/firestore_service.dart';
import '../widgets/cd_spine_widget.dart';
import 'album_detail_screen.dart';
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
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SearchScreen())),
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: NetworkImage('https://www.transparenttextures.com/patterns/wood-pattern.png'),
                repeat: ImageRepeat.repeat,
              ),
            ),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: _firestoreService.getLibraryStream(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'Your library is empty. Tap the search icon to find and add a CD!',
                      style: TextStyle(fontSize: 18, backgroundColor: Colors.black54),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }

              List<CD> cdList = snapshot.data!.docs.map((doc) => CD.fromFirestore(doc)).toList();

              return ReorderableGridView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: cdList.length,
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 100,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 0.4,
                ),
                itemBuilder: (context, index) {
                  CD cd = cdList[index];
                  return GestureDetector(
                    key: ValueKey(cd.id),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AlbumDetailScreen(
                          cd: cd,
                          // Le decimos a la pantalla de detalle que venimos de la librería
                          sourceCollection: 'library',
                        ),
                      ),
                    ),
                    child: CdSpineWidget(
                      title: cd.title,
                      artist: cd.artist,
                      coverUrl: cd.coverUrl,
                    ),
                  );
                },
                onReorder: (oldIndex, newIndex) {
                  final cd = cdList.removeAt(oldIndex);
                  cdList.insert(newIndex, cd);
                  _firestoreService.updateLibraryOrder(cdList);
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
