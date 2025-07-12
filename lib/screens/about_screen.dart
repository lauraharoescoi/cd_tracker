import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Center(
              child: Column(
                children: [
                  const Icon(
                    Icons.album,
                    size: 80,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'CD Tracker',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Version 1.0.0',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            _buildSectionTitle(context, 'Developer'),
            const SizedBox(height: 8),
            _buildInfoCard(
              context,
              'Created by Laura Haro Escoi',
              '🤠',
              Icons.person,
            ),
            const SizedBox(height: 20),
            _buildSectionTitle(context, 'Technology'),
            const SizedBox(height: 8),
            _buildInfoCard(
              context,
              'Powered by Spotify API',
              'This app uses the Spotify Web API to fetch album information, artwork, and music data.',
              Icons.music_note,
            ),
            const SizedBox(height: 20),
            _buildSectionTitle(context, 'Open Source'),
            const SizedBox(height: 8),
            _buildInfoCard(
              context,
              'MIT License',
              'This application is open source and available under the MIT License. You are free to use, modify, and distribute this code.',
              Icons.code,
            ),
            const SizedBox(height: 20),
            _buildSectionTitle(context, 'Links'),
            const SizedBox(height: 8),
            _buildLinkCard(
              context,
              'GitHub Repository',
              'View the source code and contribute to the project',
              Icons.code_outlined,
              'https://github.com/lauraharoescoi',
            ),
            const SizedBox(height: 40),
            _buildSectionTitle(context, 'About the App'),
            const SizedBox(height: 8),
            _buildInfoCard(
              context,
              'CD Tracker',
              'Keep track of your physical CD collection with ease. Search for albums, manage your library, create wishlists, and organize your music collection all in one place.',
              Icons.library_music,
            ),
            const SizedBox(height: 20),
            _buildInfoCard(
              context,
              'Features',
              '• Search and browse albums\n• Track your physical CD collection\n• Create and manage wishlists\n• View detailed album information\n• Beautiful album artwork display',
              Icons.star,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, String title, String description, IconData icon) {
    return Card(
      color: Colors.grey[900],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 24,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLinkCard(BuildContext context, String title, String description, IconData icon, String url) {
    return Card(
      color: Colors.grey[900],
      child: InkWell(
        onTap: () => _launchURL(url),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                icon,
                color: Colors.white,
                size: 24,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.open_in_new,
                color: Colors.white70,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
} 