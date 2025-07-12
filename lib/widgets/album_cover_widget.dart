import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AlbumCoverWidget extends StatelessWidget {
  final String title;
  final String artist;
  final String coverUrl;

  const AlbumCoverWidget({
    super.key,
    required this.title,
    required this.artist,
    required this.coverUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      color: Colors.grey[900],
      clipBehavior: Clip.antiAlias, // Importante para que el borde redondeado afecte a la imagen
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Carátula del álbum
          Expanded(
            child: coverUrl.isNotEmpty
                ? Image.network(
                    coverUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.album, size: 50, color: Colors.white70),
                  )
                : const Icon(Icons.album, size: 50, color: Colors.white70),
          ),
          // Información del álbum
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: Colors.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  artist,
                  style: GoogleFonts.montserrat(
                    fontSize: 11,
                    color: Colors.white70,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
