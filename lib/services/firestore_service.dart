import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/cd_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // --- Library Methods ---
  CollectionReference get _libraryCollection => _db.collection('library');
  
  Stream<QuerySnapshot> getLibraryStream() => _libraryCollection.snapshots();
  Future<void> addCDToLibrary(Map<String, dynamic> cdData) => _libraryCollection.add(cdData);
  Future<void> deleteCDFromLibrary(String docId) => _libraryCollection.doc(docId).delete();

  // --- Wishlist Methods ---
  CollectionReference get _wishlistCollection => _db.collection('wishlist');

  Stream<QuerySnapshot> getWishlistStream() => _wishlistCollection.snapshots();
  Future<void> addCDToWishlist(Map<String, dynamic> cdData) => _wishlistCollection.add(cdData);
  Future<void> deleteCDFromWishlist(String docId) => _wishlistCollection.doc(docId).delete();

  // --- Move from Wishlist to Library ---
  Future<void> moveCDFromWishlistToLibrary(CD cd) async {
    WriteBatch batch = _db.batch();
    DocumentReference wishlistDocRef = _wishlistCollection.doc(cd.id);
    batch.delete(wishlistDocRef);
    DocumentReference libraryDocRef = _libraryCollection.doc(); // Create new doc in library
    batch.set(libraryDocRef, cd.toMap()); // Use toMap to include spotifyId
    await batch.commit();
  }
}