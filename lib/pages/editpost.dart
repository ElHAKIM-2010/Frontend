// lib/pages/editpost.dart
// Halaman "Edit Artikel" untuk mengubah postingan yang sudah ada.
import 'package:flutter/material.dart';
import '../models/post.dart';
import '../theme.dart';
import 'post_form.dart';

class EditPostPage extends StatelessWidget {
  // Artikel lama yang sedang diedit.
  final Post post;

  const EditPostPage({
    super.key,
    required this.post,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: const Text('Edit Artikel'),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(color: AppColors.line),
        ),
      ),
      body: PostForm(
        submitLabel: 'Simpan',
        // Form diisi data lama (initialPost); saat disimpan,
        // hasil edit dikembalikan ke halaman detail.
        initialPost: post,
        onSubmit: (updated) => Navigator.pop(context, updated),
      ),
    );
  }
}