import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/cd_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Obtener el ID del usuario actual
  String? get _userId => _auth.currentUser?.uid;

  // --- Métodos de la Librería ---
  CollectionReference get _libraryCollection {
    if (_userId == null) throw Exception("User not logged in");
    return _db.collection('users').doc(_userId).collection('library');
  }
  
  Stream<QuerySnapshot> getLibraryStream() => _libraryCollection.orderBy('orderIndex').snapshots();
  
  Future<void> addCDToLibrary(Map<String, dynamic> cdData) async {
    final querySnapshot = await _libraryCollection.orderBy('orderIndex', descending: true).limit(1).get();
    int newIndex = 0;
    if (querySnapshot.docs.isNotEmpty) {
      newIndex = (querySnapshot.docs.first.data() as Map<String, dynamic>)['orderIndex'] + 1;
    }
    cdData['orderIndex'] = newIndex;
    await _libraryCollection.add(cdData);
  }

  Future<void> deleteCDFromLibrary(String docId) => _libraryCollection.doc(docId).delete();

  Future<void> updateLibraryOrder(List<CD> reorderedCds) {
    WriteBatch batch = _db.batch();
    for (int i = 0; i < reorderedCds.length; i++) {
      DocumentReference docRef = _libraryCollection.doc(reorderedCds[i].id);
      batch.update(docRef, {'orderIndex': i});
    }
    return batch.commit();
  }

  // --- Métodos de la Wishlist ---
  CollectionReference get _wishlistCollection {
    if (_userId == null) throw Exception("User not logged in");
    return _db.collection('users').doc(_userId).collection('wishlist');
  }

  Stream<QuerySnapshot> getWishlistStream() => _wishlistCollection.snapshots();
  
  Future<void> addCDToWishlist(Map<String, dynamic> cdData) async {
    await _wishlistCollection.add(cdData);
  }

  Future<void> deleteCDFromWishlist(String docId) => _wishlistCollection.doc(docId).delete();
  
  Future<void> moveCDFromWishlistToLibrary(CD cd) async {
    final querySnapshot = await _libraryCollection.orderBy('orderIndex', descending: true).limit(1).get();
    int newIndex = 0;
    if (querySnapshot.docs.isNotEmpty) {
      newIndex = (querySnapshot.docs.first.data() as Map<String, dynamic>)['orderIndex'] + 1;
    }
    
    WriteBatch batch = _db.batch();
    DocumentReference wishlistDocRef = _wishlistCollection.doc(cd.id);
    batch.delete(wishlistDocRef);
    DocumentReference libraryDocRef = _libraryCollection.doc();
    
    Map<String, dynamic> cdData = cd.toMap();
    cdData['orderIndex'] = newIndex;
    
    batch.set(libraryDocRef, cdData);
    await batch.commit();
  }
}