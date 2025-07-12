import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/cd_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // --- Library Methods ---
  CollectionReference get _libraryCollection => _db.collection('library');
  
  // GET: Leer stream ordenado por el nuevo campo
  Stream<QuerySnapshot> getLibraryStream() {
    return _libraryCollection.orderBy('orderIndex').snapshots();
  }
  
  // CREATE: Añadir un nuevo CD con un índice de orden
  Future<void> addCDToLibrary(Map<String, dynamic> cdData) async {
    // Obtenemos el índice más alto actual para poner el nuevo CD al final
    final querySnapshot = await _libraryCollection.orderBy('orderIndex', descending: true).limit(1).get();
    int newIndex = 0;
    if (querySnapshot.docs.isNotEmpty) {
      newIndex = (querySnapshot.docs.first.data() as Map<String, dynamic>)['orderIndex'] + 1;
    }
    cdData['orderIndex'] = newIndex;
    // CORRECCIÓN: Usamos await y no devolvemos nada para que coincida con Future<void>
    await _libraryCollection.add(cdData);
  }

  Future<void> deleteCDFromLibrary(String docId) => _libraryCollection.doc(docId).delete();

  // NUEVO: Actualizar el orden de la librería
  Future<void> updateLibraryOrder(List<CD> reorderedCds) {
    WriteBatch batch = _db.batch();
    for (int i = 0; i < reorderedCds.length; i++) {
      DocumentReference docRef = _libraryCollection.doc(reorderedCds[i].id);
      batch.update(docRef, {'orderIndex': i});
    }
    return batch.commit();
  }

  // --- Wishlist Methods ---
  CollectionReference get _wishlistCollection => _db.collection('wishlist');
  Stream<QuerySnapshot> getWishlistStream() => _wishlistCollection.snapshots();
  
  Future<void> addCDToWishlist(Map<String, dynamic> cdData) async {
    // CORRECCIÓN: Aplicamos la misma lógica aquí para ser consistentes
    await _wishlistCollection.add(cdData);
  }

  Future<void> deleteCDFromWishlist(String docId) => _wishlistCollection.doc(docId).delete();
  
  Future<void> moveCDFromWishlistToLibrary(CD cd) async {
    // Lógica para mover de wishlist a library, ahora también debe asignar un orderIndex
    final querySnapshot = await _libraryCollection.orderBy('orderIndex', descending: true).limit(1).get();
    int newIndex = 0;
    if (querySnapshot.docs.isNotEmpty) {
      newIndex = (querySnapshot.docs.first.data() as Map<String, dynamic>)['orderIndex'] + 1;
    }
    
    WriteBatch batch = _db.batch();
    DocumentReference wishlistDocRef = _wishlistCollection.doc(cd.id);
    batch.delete(wishlistDocRef);
    DocumentReference libraryDocRef = _libraryCollection.doc();
    
    // Crear el mapa con los datos del CD y el nuevo índice
    Map<String, dynamic> cdData = cd.toMap();
    cdData['orderIndex'] = newIndex;
    
    batch.set(libraryDocRef, cdData);
    await batch.commit();
  }
}
