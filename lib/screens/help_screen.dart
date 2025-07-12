import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHelpSection(
              context,
              icon: Icons.search,
              title: 'Searching for Albums',
              content: 'Tap the search icon in the top-right corner of the "Library" or "Wishlist" tabs. Type an album or artist name and press search. You will see a list of results from Spotify.',
            ),
            _buildHelpSection(
              context,
              icon: Icons.add_box_outlined,
              title: 'Adding to Your Library',
              content: 'In the search results, tap the box icon (+) next to an album to add it directly to your personal library.',
            ),
            _buildHelpSection(
              context,
              icon: Icons.favorite_border,
              title: 'Using the Wishlist',
              content: 'In the search results, tap the heart icon to add an album to your wishlist. In the "Wishlist" tab, you can see all the albums you want to buy. Tap the shopping cart icon to move it to your library once you have it.',
            ),
            _buildHelpSection(
              context,
              icon: Icons.open_with,
              title: 'Reordering Your Library',
              content: 'In the "My Library" tab, press and hold an album cover, then drag it to a new position to organize your collection just the way you like it. The order will be saved automatically.',
            ),
            _buildHelpSection(
              context,
              icon: Icons.info_outline,
              title: 'Viewing Album Details',
              content: 'Tap on any album cover in your library or any item in your wishlist to see a detailed view with the tracklist, release date, and other information. From this screen, you can also delete the album or listen to it on Spotify.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHelpSection(BuildContext context, {required IconData icon, required String title, required String content}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              content,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}
