import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../services/spotify_service.dart';
import '../services/firestore_service.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final SpotifyService _spotifyService = SpotifyService();
  final FirestoreService _firestoreService = FirestoreService();
  final TextEditingController _searchController = TextEditingController();

  List<dynamic> _searchResults = [];
  bool _isLoading = false;

  // Sets to store the Spotify IDs of albums in our collections
  Set<String> _librarySpotifyIds = {};
  Set<String> _wishlistSpotifyIds = {};

  // Stream subscriptions to listen for real-time changes
  late StreamSubscription _librarySubscription;
  late StreamSubscription _wishlistSubscription;

  @override
  void initState() {
    super.initState();
    _listenToCollections();
  }

  // Listen to both library and wishlist streams to get the latest data
  void _listenToCollections() {
    _librarySubscription = _firestoreService.getLibraryStream().listen((snapshot) {
      if (!mounted) return;
      final ids = snapshot.docs.map((doc) => (doc.data() as Map<String, dynamic>)['spotifyId'] as String).toSet();
      setState(() => _librarySpotifyIds = ids);
    });

    _wishlistSubscription = _firestoreService.getWishlistStream().listen((snapshot) {
      if (!mounted) return;
      final ids = snapshot.docs.map((doc) => (doc.data() as Map<String, dynamic>)['spotifyId'] as String).toSet();
      setState(() => _wishlistSpotifyIds = ids);
    });
  }

  @override
  void dispose() {
    // Cancel subscriptions to prevent memory leaks
    _librarySubscription.cancel();
    _wishlistSubscription.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch() async {
    if (_searchController.text.isEmpty) return;
    setState(() => _isLoading = true);
    final results = await _spotifyService.searchAlbums(_searchController.text);
    setState(() {
      _searchResults = results;
      _isLoading = false;
    });
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 1)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search for an Album'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Album or Artist Name',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _performSearch,
                ),
              ),
              onSubmitted: (_) => _performSearch(),
            ),
          ),
          if (_isLoading)
            const Expanded(child: Center(child: CircularProgressIndicator()))
          else
            Expanded(
              child: ListView.builder(
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                  final album = _searchResults[index];
                  final spotifyId = album['id'];
                  final imageUrl = album['images'].isNotEmpty ? album['images'][0]['url'] : '';
                  final artistName = album['artists'].isNotEmpty ? album['artists'][0]['name'] : 'Unknown Artist';

                  // Determine the status of the album
                  final isInLibrary = _librarySpotifyIds.contains(spotifyId);
                  final isInWishlist = _wishlistSpotifyIds.contains(spotifyId);

                  return ListTile(
                    leading: imageUrl.isNotEmpty
                        ? Image.network(imageUrl, width: 50, height: 50, fit: BoxFit.cover)
                        : const Icon(Icons.album, size: 50),
                    title: Text(album['name']),
                    subtitle: Text(artistName),
                    trailing: isInLibrary
                        ? const Icon(Icons.check_circle, color: Colors.green, semanticLabel: 'In Library')
                        : isInWishlist
                            ? const Icon(Icons.favorite, color: Colors.pink, semanticLabel: 'In Wishlist')
                            : Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.favorite_border),
                                    tooltip: 'Add to Wishlist',
                                    onPressed: () {
                                      final cdData = {'spotifyId': spotifyId, 'title': album['name'], 'artist': artistName, 'coverUrl': imageUrl};
                                      _firestoreService.addCDToWishlist(cdData).then((_) {
                                        _showSnackBar('${album['name']} added to your wishlist!');
                                      });
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.add_box),
                                    tooltip: 'Add to Library',
                                    onPressed: () {
                                      final cdData = {'spotifyId': spotifyId, 'title': album['name'], 'artist': artistName, 'coverUrl': imageUrl};
                                      _firestoreService.addCDToLibrary(cdData).then((_) {
                                        _showSnackBar('${album['name']} added to your library!');
                                      });
                                    },
                                  ),
                                ],
                              ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
