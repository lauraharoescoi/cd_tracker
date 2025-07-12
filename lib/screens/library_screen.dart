import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/cd_model.dart';
import '../services/firestore_service.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  // Instance of our Firestore service
  final FirestoreService _firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Library'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      // Use a StreamBuilder to listen for real-time updates from Firestore
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestoreService.getLibraryStream(),
        builder: (context, snapshot) {
          // If the snapshot has data, display it
          if (snapshot.hasData) {
            List<CD> cdList = snapshot.data!.docs
                .map((doc) => CD.fromFirestore(doc))
                .toList();

            // If the list is empty, show a message
            if (cdList.isEmpty) {
              return const Center(
                child: Text(
                  'Your library is empty. Add a CD to get started!',
                  style: TextStyle(fontSize: 18),
                ),
              );
            }

            // If there are CDs, display them in a list
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
                );
              },
            );
          }
          // If the data is still loading, show a progress indicator
          else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          // If there is an error
          else {
            return const Center(
              child: Text("Something went wrong."),
            );
          }
        },
      ),
      // Floating Action Button to add a test CD
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _firestoreService.addDummyCD();
        },
        tooltip: 'Add Dummy CD',
        child: const Icon(Icons.add),
      ),
    );
  }
}