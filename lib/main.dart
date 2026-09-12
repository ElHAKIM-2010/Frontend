// lib/main.dart
// Titik awal aplikasi: membuat dan menjalankan aplikasi Blog.
import 'package:flutter/material.dart';
import 'homepage.dart';
import 'theme.dart';

void main() {
  runApp(const BlogApp());
}

// Widget akar (root) aplikasi; mengatur tema dan halaman pertama.
class BlogApp extends StatelessWidget {
  const BlogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplikasi Blog',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      home: const HomePage(),
    );
  }
}