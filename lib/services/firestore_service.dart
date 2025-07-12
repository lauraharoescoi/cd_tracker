import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  // Get the collection of CDs from 'library'
  final CollectionReference libraryCollection =
      FirebaseFirestore.instance.collection('library');

  // GET: Read stream of documents from 'library' collection
  Stream<QuerySnapshot> getLibraryStream() {
    return libraryCollection.snapshots();
  }
  
  // A helper function to add a dummy CD for testing
  Future<void> addDummyCD() {
    return libraryCollection.add({
      'title': 'The Dark Side of the Moon',
      'artist': 'Pink Floyd',
      'coverUrl': 'https://upload.wikimedia.org/wikipedia/en/3/3b/Dark_Side_of_the_Moon.png'
    });
  }
}