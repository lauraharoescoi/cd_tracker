import 'package:cloud_firestore/cloud_firestore.dart';

class CD {
  final String id;
  final String title;
  final String artist;
  final String coverUrl;

  CD({
    required this.id,
    required this.title,
    required this.artist,
    required this.coverUrl,
  });

  factory CD.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return CD(
      id: doc.id,
      title: data['title'] ?? 'No Title',
      artist: data['artist'] ?? 'No Artist',
      coverUrl: data['coverUrl'] ?? '',
    );
  }
  
  // Method to convert CD instance to a map for Firestore
  // Este es el método que faltaba
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'artist': artist,
      'coverUrl': coverUrl,
    };
  }
}