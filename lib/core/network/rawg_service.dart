import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import '../utils/file_helper.dart';

class RawgGameResult {
  final String title;
  final String? imageUrl;
  final List<String> genres;
  final int? releaseYear;

  RawgGameResult({
    required this.title,
    this.imageUrl,
    required this.genres,
    this.releaseYear,
  });

  factory RawgGameResult.fromJson(Map<String, dynamic> json) {
    final genresList = (json['genres'] as List<dynamic>?)
            ?.map((g) => g['name'] as String)
            .toList() ??
        [];
    int? year;
    if (json['released'] != null) {
      year = DateTime.tryParse(json['released'] as String)?.year;
    }
    return RawgGameResult(
      title: json['name'] as String? ?? '',
      imageUrl: json['background_image'] as String?,
      genres: genresList,
      releaseYear: year,
    );
  }
}

class RawgService {
  // Pengguna bisa mengganti API key default di sini atau lewat dialog pengaturan
  static String apiKey = '';

  /// Cari game berdasarkan query (maksimal 5 hasil teratas)
  static Future<List<RawgGameResult>> search(String query) async {
    if (apiKey.isEmpty) throw Exception('API Key RAWG belum diatur');
    if (query.trim().isEmpty) return [];

    final uri = Uri.parse(
      'https://api.rawg.io/api/games?key=$apiKey&search=${Uri.encodeComponent(query)}&page_size=5',
    );

    final response = await http.get(uri);
    if (response.statusCode != 200) {
      throw Exception('Gagal memuat data dari RAWG (${response.statusCode})');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final results = data['results'] as List<dynamic>? ?? [];
    return results
        .map((e) => RawgGameResult.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Unduh gambar cover dari URL dan simpan permanen via FileHelper
  static Future<String?> downloadAndSaveCover(String imageUrl) async {
    try {
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode != 200) return null;

      final tempDir = await getTemporaryDirectory();
      final tempFile = File(
          '${tempDir.path}/rawg_temp_${DateTime.now().millisecondsSinceEpoch}.jpg');
      await tempFile.writeAsBytes(response.bodyBytes);

      return await FileHelper.saveCoverImage(tempFile);
    } catch (_) {
      return null;
    }
  }
}
