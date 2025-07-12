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

  void _performSearch() async {
    if (_searchController.text.isEmpty) {
      return;
    }
    setState(() {
      _isLoading = true;
    });
    final results = await _spotifyService.searchAlbums(_searchController.text);
    setState(() {
      _searchResults = results;
      _isLoading = false;
    });
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
                  final imageUrl = album['images'].isNotEmpty ? album['images'][0]['url'] : '';
                  final artistName = album['artists'].isNotEmpty ? album['artists'][0]['name'] : 'Unknown Artist';

                  return ListTile(
                    leading: imageUrl.isNotEmpty
                        ? Image.network(imageUrl, width: 50, height: 50, fit: BoxFit.cover)
                        : const Icon(Icons.album, size: 50),
                    title: Text(album['name']),
                    subtitle: Text(artistName),
                    trailing: IconButton(
                      icon: const Icon(Icons.add_box),
                      tooltip: 'Add to Library',
                      onPressed: () {
                        final cdData = {
                          'title': album['name'],
                          'artist': artistName,
                          'coverUrl': imageUrl,
                        };
                        _firestoreService.addCDToLibrary(cdData).then((_) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('${album['name']} added to your library!')),
                          );
                        });
                      },
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