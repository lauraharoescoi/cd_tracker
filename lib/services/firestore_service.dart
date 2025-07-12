import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final CollectionReference libraryCollection = FirebaseFirestore.instance.collection('library');
  final CollectionReference wishlistCollection = FirebaseFirestore.instance.collection('wishlist');

  // GET: Leer stream de documentos de la colección 'library'
  Stream<QuerySnapshot> getLibraryStream() {
    return libraryCollection.snapshots();
  }

  // CREATE: Añadir un nuevo CD a la librería
  Future<void> addCDToLibrary(Map<String, dynamic> cdData) {
    return libraryCollection.add(cdData);
  }

  // DELETE: Borrar un CD de la librería usando su ID
  Future<void> deleteCDFromLibrary(String docId) {
    return libraryCollection.doc(docId).delete();
  }
}
