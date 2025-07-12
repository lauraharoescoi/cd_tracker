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

  // Factory constructor to create a CD from a Firestore document
  factory CD.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return CD(
      id: doc.id,
      title: data['title'] ?? 'No Title',
      artist: data['artist'] ?? 'No Artist',
      coverUrl: data['coverUrl'] ?? '',
    );
  }
}