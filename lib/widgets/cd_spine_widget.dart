import 'package:flutter/material.dart';

class CdSpineWidget extends StatelessWidget {
  final String title;
  final String artist;
  final String coverUrl;

  const CdSpineWidget({
    super.key,
    required this.title,
    required this.artist,
    required this.coverUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80, // Ancho del lomo del CD
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Imagen de fondo (la carátula)
            if (coverUrl.isNotEmpty)
              Image.network(
                coverUrl,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
              ),
            // Un degradado oscuro para que el texto sea legible
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black.withOpacity(0.8), Colors.black.withOpacity(0.4)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
            ),
            // Texto vertical
            RotatedBox(
              quarterTurns: 1, // Gira el texto 90 grados
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    artist,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
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
}