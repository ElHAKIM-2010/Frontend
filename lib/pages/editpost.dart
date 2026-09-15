// lib/pages/editpost.dart
// Halaman "Edit Artikel" untuk mengubah postingan yang sudah ada.

import 'package:flutter/material.dart';

import '../models/post.dart';
import '../services/api_service.dart';
import '../theme.dart';
import 'post_form.dart';

class EditPostPage extends StatelessWidget {
  final Post post;

  const EditPostPage({super.key, required this.post});

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
        initialPost: post,
        onSubmit: (updatedPost) async {
          if (post.id == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('ID artikel tidak ditemukan.')),
            );
            return;
          }

          try {
            await ApiService.updatePost(
              id: post.id!,
              title: updatedPost.title,
              content: updatedPost.content,
              categoryId: 1,
            );

            if (!context.mounted) return;

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Artikel berhasil diperbarui.')),
            );

            Navigator.pop(context, updatedPost);
          } catch (error) {
            if (!context.mounted) return;

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Gagal memperbarui artikel: $error')),
            );
          }
        },
      ),
    );
  }
}
