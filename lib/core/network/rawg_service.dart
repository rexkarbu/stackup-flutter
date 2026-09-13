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

  static bool _isExcludedTag(String tagLower) {
    // 1. Steam & Store / Technical
    if (tagLower.contains('steam') ||
        tagLower.contains('controller') ||
        tagLower.contains('cloud') ||
        tagLower.contains('achievement') ||
        tagLower.contains('trading card') ||
        tagLower.contains('workshop') ||
        tagLower.contains('leaderboard') ||
        tagLower.contains('remote play') ||
        tagLower.contains('in-app') ||
        tagLower.contains('captions') ||
        tagLower.contains('commentary') ||
        tagLower.contains('level editor') ||
        tagLower.contains('exclusive') ||
        tagLower.contains('cross-platform') ||
        tagLower.contains('geforce') ||
        tagLower.contains('family sharing') ||
        tagLower.contains('hdr') ||
        tagLower.contains('vr') ||
        tagLower.contains('trackir')) {
      return true;
    }

    // 2. Adult / Mature content tags
    if (tagLower.contains('sexual') ||
        tagLower.contains('nudity') ||
        tagLower.contains('nsfw') ||
        tagLower.contains('erotic') ||
        tagLower.contains('hentai') ||
        tagLower.contains('gore') ||
        tagLower.contains('blood') ||
        tagLower == 'violent' ||
        tagLower == 'violence') {
      return true;
    }

    // 3. Redundant / rating / store hype tags / non-genre
    if (tagLower.contains('soundtrack') ||
        tagLower.contains('music') ||
        tagLower == 'masterpiece' ||
        tagLower == 'remake' ||
        tagLower == 'remaster' ||
        tagLower == 're-release' ||
        tagLower == 'mod' ||
        tagLower == 'mods' ||
        tagLower == 'stats' ||
        tagLower == 'singleplayer') {
      return true;
    }

    return false;
  }

  factory RawgGameResult.fromJson(Map<String, dynamic> json) {
    final rawGenres = (json['genres'] as List<dynamic>?)
            ?.map((g) => (g['name'] as String?)?.trim() ?? '')
            .where((g) => g.isNotEmpty)
            .toList() ??
        [];

    final List<String> enrichedGenres = List<String>.from(rawGenres);
    final seen = rawGenres.map((g) => g.toLowerCase()).toSet();

    // Ekstraksi tag yang relevan dari tags untuk melengkapi genre (misal: JRPG, Anime, Story Rich, Turn-Based, dll.)
    final rawTags = json['tags'] as List<dynamic>? ?? [];
    for (final t in rawTags) {
      if (t is! Map<String, dynamic>) continue;
      final lang = t['language'] as String?;
      if (lang != null && lang != 'eng') continue;

      final name = (t['name'] as String?)?.trim() ?? '';
      if (name.isEmpty) continue;

      final nameLower = name.toLowerCase();
      if (seen.contains(nameLower)) continue;
      if (_isExcludedTag(nameLower)) continue;

      seen.add(nameLower);
      enrichedGenres.add(name);

      if (enrichedGenres.length >= 6) break;
    }

    int? year;
    if (json['released'] != null) {
      year = DateTime.tryParse(json['released'] as String)?.year;
    }
    return RawgGameResult(
      title: json['name'] as String? ?? '',
      imageUrl: json['background_image'] as String?,
      genres: enrichedGenres,
      releaseYear: year,
    );
  }
}

class RawgService {
  // Default API Key RAWG (bisa diubah manual lewat UI jika diperlukan)
  static String apiKey = 'f0e632a31cb949648552c2ad23b77767';

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
