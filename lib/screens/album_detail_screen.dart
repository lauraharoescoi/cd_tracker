import 'package:flutter/material.dart';
import '../models/cd_model.dart';
import '../services/spotify_service.dart';

class AlbumDetailScreen extends StatefulWidget {
  final CD cd;

  const AlbumDetailScreen({super.key, required this.cd});

  @override
  State<AlbumDetailScreen> createState() => _AlbumDetailScreenState();
}

class _AlbumDetailScreenState extends State<AlbumDetailScreen> {
  final SpotifyService _spotifyService = SpotifyService();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.cd.title),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _albumDetails == null
              ? const Center(child: Text('Could not load album details.'))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: widget.cd.coverUrl.isNotEmpty
                              ? Image.network(
                                  widget.cd.coverUrl,
                                  height: 300,
                                  width: 300,
                                  fit: BoxFit.cover,
                                )
                              : const Icon(Icons.album, size: 300),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        widget.cd.title,
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.cd.artist,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white70),
                      ),
                      const SizedBox(height: 16),
                      _buildDetailRow(Icons.calendar_today, 'Release Date', _albumDetails!['release_date']),
                      _buildDetailRow(Icons.track_changes, 'Tracks', _albumDetails!['total_tracks'].toString()),
                      _buildDetailRow(Icons.label, 'Label', _albumDetails!['label']),
                      const SizedBox(height: 24),
                      Text(
                        'Tracklist',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const Divider(),
                      _buildTracklist(_albumDetails!['tracks']['items']),
                    ],
                  ),
                ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.white70),
          const SizedBox(width: 8),
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value, overflow: TextOverflow.ellipsis)),
        ],
      ),
    );
  }

  Widget _buildTracklist(List<dynamic> tracks) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: tracks.length,
      itemBuilder: (context, index) {
        final track = tracks[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${track['track_number']}.', style: const TextStyle(color: Colors.white70)),
              const SizedBox(width: 16),
              Expanded(child: Text(track['name'])),
            ],
          ),
        );
      },
    );
  }
}
