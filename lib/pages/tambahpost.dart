// lib/pages/tambahpost.dart
import 'package:flutter/material.dart';

import '../theme.dart';
import '../services/api_service.dart';
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
        onSubmit: (post) async {
          try {
            await ApiService.createPost(
              title: post.title,
              content: post.content,
              categoryId: 1,
            );

            if (!context.mounted) return;

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Artikel berhasil diterbitkan')),
            );

            Navigator.pop(context, post);
          } catch (error) {
            if (!context.mounted) return;

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Gagal menerbitkan artikel: $error')),
            );
          }
        },
      ),
    );
  }
}
