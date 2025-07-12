import 'package:cloud_firestore/cloud_firestore.dart';

class CD {
  final String id; // Firestore document ID
  final String spotifyId; // Spotify's unique album ID
  final String title;
  final String artist;
  final String coverUrl;
  final int orderIndex; // NUEVO: Para guardar el orden

  CD({
    required this.id,
    required this.spotifyId,
    required this.title,
    required this.artist,
    required this.coverUrl,
    required this.orderIndex,
  });

  // Factory to create a CD from a Firestore document
  factory CD.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return CD(
      id: doc.id,
      spotifyId: data['spotifyId'] ?? '',
      title: data['title'] ?? 'No Title',
      artist: data['artist'] ?? 'No Artist',
      coverUrl: data['coverUrl'] ?? '',
      orderIndex: data['orderIndex'] ?? 0,
    );
  }
  
  // Method to convert CD instance to a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'spotifyId': spotifyId,
      'title': title,
      'artist': artist,
      'coverUrl': coverUrl,
      'orderIndex': orderIndex,
    };
  }
}
