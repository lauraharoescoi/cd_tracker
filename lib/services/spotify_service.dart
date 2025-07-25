import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/credentials.dart';

class SpotifyService {
  String? _accessToken;
  DateTime? _tokenExpiration;

  Future<String?> _getAccessToken() async {
    if (_accessToken != null && _tokenExpiration != null && DateTime.now().isBefore(_tokenExpiration!)) {
      return _accessToken;
    }

    final response = await http.post(
      Uri.parse('https://accounts.spotify.com/api/token'),
      headers: {
        'Authorization': 'Basic ${base64Encode(utf8.encode('$spotifyClientId:$spotifyClientSecret'))}',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: 'grant_type=client_credentials',
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      _accessToken = data['access_token'];
      _tokenExpiration = DateTime.now().add(Duration(seconds: data['expires_in']));
      return _accessToken;
    } else {
      print('Failed to get Spotify access token. Check your credentials in lib/config/spotify_credentials.dart');
      return null;
    }
  }

  Future<List<dynamic>> searchAlbums(String query) async {
    final token = await _getAccessToken();
    if (token == null) return [];

    final response = await http.get(
      Uri.parse('https://api.spotify.com/v1/search?q=$query&type=album&limit=20'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['albums']['items'];
    } else {
      print('Failed to search albums');
      return [];
    }
  }

  // NUEVO: Obtener detalles de un álbum específico
  Future<Map<String, dynamic>?> getAlbumDetails(String spotifyId) async {
    final token = await _getAccessToken();
    if (token == null) return null;

    final response = await http.get(
      Uri.parse('https://api.spotify.com/v1/albums/$spotifyId'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print('Failed to get album details');
      return null;
    }
  }
}
