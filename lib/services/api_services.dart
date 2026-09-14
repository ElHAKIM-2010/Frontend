import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiService {
  // Untuk Android Emulator
  static const String baseUrl = 'http://localhost:3000/api';

  // Kalau menggunakan HP asli, ganti 10.0.2.2
  // dengan IP laptop kamu, contoh:
  // http://localhost:3000/api//
  static Future<List<dynamic>> getPosts() async {
    final response = await http.get(Uri.parse('$baseUrl/posts'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Gagal mengambil artikel');
    }
  }

  static Future<void> deletePost(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/posts/$id'));

    if (response.statusCode != 200) {
      throw Exception('Gagal menghapus artikel');
    }
  }
}
