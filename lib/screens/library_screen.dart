import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:reorderable_grid_view/reorderable_grid_view.dart';
import '../models/cd_model.dart';
import '../services/firestore_service.dart';
import '../widgets/album_cover_widget.dart';
import 'album_detail_screen.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  final FirestoreService _firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    // CORRECCIÓN: Se ha quitado el Scaffold y el AppBar de aquí.
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: NetworkImage('https://www.transparenttextures.com/patterns/dark-wood.png'),
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
              return Center(
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(16)
                  ),
                  child: const Text(
                    'Your library is empty.\nTap the search icon to add a CD!',
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }

            List<CD> cdList = snapshot.data!.docs.map((doc) => CD.fromFirestore(doc)).toList();

            return ReorderableGridView.builder(
              // El padding ahora es más simple porque el AppBar ya no está aquí
              padding: const EdgeInsets.all(12),
              itemCount: cdList.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.75,
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
                        sourceCollection: 'library',
                      ),
                    ),
                  ),
                  child: AlbumCoverWidget(
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
    );
  }
}