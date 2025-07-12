import 'package:flutter/material.dart';
import 'dart:ui';
import '../models/cd_model.dart';
import '../services/firestore_service.dart';
import '../services/spotify_service.dart';

class AlbumDetailScreen extends StatefulWidget {
  final CD cd;
  final String sourceCollection;

  const AlbumDetailScreen({
    super.key,
    required this.cd,
    required this.sourceCollection,
  });

  @override
  State<AlbumDetailScreen> createState() => _AlbumDetailScreenState();
}

class _AlbumDetailScreenState extends State<AlbumDetailScreen> {
  final SpotifyService _spotifyService = SpotifyService();
  final FirestoreService _firestoreService = FirestoreService();
  Map<String, dynamic>? _albumDetails;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAlbumDetails();
  }

  Future<void> _fetchAlbumDetails() async {
    if (widget.cd.spotifyId.isEmpty) {
      if (mounted) setState(() => _isLoading = false);
      return;
    }
    final details = await _spotifyService.getAlbumDetails(widget.cd.spotifyId);
    if (mounted) {
      setState(() {
        _albumDetails = details;
        _isLoading = false;
      });
    }
  }

  Future<void> _showDeleteConfirmationDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete "${widget.cd.title}" from your ${widget.sourceCollection}?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.redAccent),
              child: const Text('Delete'),
              onPressed: () {
                if (widget.sourceCollection == 'library') {
                  _firestoreService.deleteCDFromLibrary(widget.cd.id);
                } else {
                  _firestoreService.deleteCDFromWishlist(widget.cd.id);
                }
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _albumDetails == null
              ? const Center(child: Text('Could not load album details.'))
              : CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      expandedHeight: 350.0,
                      pinned: true,
                      backgroundColor: const Color(0xFF1e1e1e),
                      actions: [
                        IconButton(
                          icon: const Icon(Icons.delete_forever_outlined),
                          tooltip: 'Delete from ${widget.sourceCollection}',
                          onPressed: _showDeleteConfirmationDialog,
                        )
                      ],
                      flexibleSpace: FlexibleSpaceBar(
                        title: Text(
                          widget.cd.title,
                          style: const TextStyle(fontSize: 16.0, shadows: [Shadow(blurRadius: 4)]),
                          textAlign: TextAlign.center,
                        ),
                        centerTitle: true,
                        background: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.network(
                              widget.cd.coverUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => const Icon(Icons.album, size: 150),
                            ),
                            BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                              child: Container(
                                color: Colors.black.withOpacity(0.4),
                              ),
                            ),
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 50.0), // Adjust padding to not overlap with title
                                child: Hero(
                                  tag: widget.cd.id,
                                  child: Material(
                                    elevation: 15,
                                    borderRadius: BorderRadius.circular(12),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.network(
                                        widget.cd.coverUrl,
                                        height: 200,
                                        width: 200,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SliverList(
                      delegate: SliverChildListDelegate([
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.cd.artist,
                                style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white70),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 24),
                              _DetailCard(
                                children: [
                                  _buildDetailRow(Icons.calendar_today, 'Release Date', _albumDetails!['release_date']),
                                  _buildDetailRow(Icons.track_changes, 'Tracks', _albumDetails!['total_tracks'].toString()),
                                  _buildDetailRow(Icons.label, 'Label', _albumDetails!['label']),
                                ],
                              ),
                              const SizedBox(height: 24),
                              Text('Tracklist', style: Theme.of(context).textTheme.titleLarge),
                              const Divider(thickness: 1, height: 20),
                              _buildTracklist(_albumDetails!['tracks']['items']),
                            ],
                          ),
                        ),
                      ]),
                    ),
                  ],
                ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 16),
          Text('$label:', style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(width: 8),
          Expanded(child: Text(value, style: TextStyle(color: Colors.grey[300]))),
        ],
      ),
    );
  }

  Widget _buildTracklist(List<dynamic> tracks) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: tracks.length,
      separatorBuilder: (context, index) => Divider(color: Colors.white.withOpacity(0.1)),
      itemBuilder: (context, index) {
        final track = tracks[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              Text(
                '${track['track_number']}.',
                style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 16),
              Expanded(child: Text(track['name'])),
            ],
          ),
        );
      },
    );
  }
}

class _DetailCard extends StatelessWidget {
  final List<Widget> children;
  const _DetailCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(children: children),
    );
  }
}
