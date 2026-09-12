// lib/pages/tambahpost.dart
// Halaman "Tulis Artikel" untuk membuat postingan baru.
import 'package:flutter/material.dart';
import '../theme.dart';
import 'post_form.dart';

class TambahPostPage extends StatelessWidget {
  const TambahPostPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: const Text('Tulis Artikel'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: AppColors.line),
        ),
      ),
      body: PostForm(
        submitLabel: 'Terbitkan',
        onSubmit: (post) {
          // TODO: kirim ke REST API -> POST /posts
          // Kembali ke halaman utama dengan membawa artikel baru.
          Navigator.pop(context, post);
        },
      ),
    );
  }
}