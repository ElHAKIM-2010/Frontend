import 'package:flutter/material.dart';

import '../models/post.dart';
import '../theme.dart';

class PostForm extends StatefulWidget {
  final String submitLabel;
  final Post? initialPost;
  final Future<void> Function(Post post) onSubmit;

  const PostForm({
    super.key,
    required this.submitLabel,
    this.initialPost,
    required this.onSubmit,
  });

  @override
  State<PostForm> createState() => _PostFormState();
}

class _PostFormState extends State<PostForm> {
  late final TextEditingController _titleController;
  late final TextEditingController _contentController;
  late final TextEditingController _categoryController;
  late final TextEditingController _authorController;

  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();

    final post = widget.initialPost;

    _titleController = TextEditingController(text: post?.title ?? '');

    _contentController = TextEditingController(text: post?.content ?? '');

    _categoryController = TextEditingController(text: post?.category ?? '');

    _authorController = TextEditingController(text: post?.author ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _categoryController.dispose();
    _authorController.dispose();
    super.dispose();
  }

  int get _readMinutes {
    final content = _contentController.text.trim();

    if (content.isEmpty) {
      return 1;
    }

    final words = content.split(RegExp(r'\s+'));
    final minutes = (words.length / 200).ceil();

    return minutes < 1 ? 1 : minutes;
  }

  String get _excerpt {
    final plain = _contentController.text.replaceAll('\n', ' ').trim();

    if (plain.length > 140) {
      return '${plain.substring(0, 140)}...';
    }

    return plain;
  }

  Future<void> _submit() async {
    if (_isSubmitting) return;

    final title = _titleController.text.trim();
    final content = _contentController.text.trim();
    final category = _categoryController.text.trim();
    final author = _authorController.text.trim();

    if (title.isEmpty ||
        content.isEmpty ||
        category.isEmpty ||
        author.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Semua kolom wajib diisi.')));
      return;
    }

    final post =
        widget.initialPost?.copyWith(
          title: title,
          content: content,
          category: category,
          author: author,
          excerpt: _excerpt,
          readMinutes: _readMinutes,
        ) ??
        Post(
          title: title,
          content: content,
          category: category,
          author: author,
          excerpt: _excerpt,
          readMinutes: _readMinutes,
        );

    setState(() {
      _isSubmitting = true;
    });

    try {
      await widget.onSubmit(post);
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Terjadi kesalahan: $error')));

      setState(() {
        _isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _SectionLabel(
            icon: Icons.title_rounded,
            label: 'Judul',
            text: 'Buat judul yang menarik pembaca.',
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(
              hintText: 'Contoh: Cara Membuat Kopi yang Enak',
            ),
            textCapitalization: TextCapitalization.sentences,
          ),
          const SizedBox(height: 24),
          _SectionLabel(
            icon: Icons.label_outline_rounded,
            label: 'Kategori',
            text: 'Kelompokkan agar mudah ditemukan.',
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _categoryController,
            decoration: const InputDecoration(
              hintText: 'Contoh: Teknologi, Tips, Pendidikan',
            ),
          ),
          const SizedBox(height: 24),
          _SectionLabel(
            icon: Icons.person_outline_rounded,
            label: 'Penulis',
            text: 'Nama yang tampil sebagai penulis.',
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _authorController,
            decoration: const InputDecoration(hintText: 'Nama kamu'),
          ),
          const SizedBox(height: 24),
          _SectionLabel(
            icon: Icons.notes_rounded,
            label: 'Isi Artikel',
            text: 'Tulis ceritamu di sini.',
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _contentController,
            decoration: const InputDecoration(hintText: 'Mulai menulis...'),
            minLines: 8,
            maxLines: null,
          ),
          const SizedBox(height: 28),
          ElevatedButton(
            onPressed: _isSubmitting ? null : _submit,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              backgroundColor: AppColors.primaryDeep,
              foregroundColor: Colors.white,
            ),
            child: _isSubmitting
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : Text(widget.submitLabel),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final IconData icon;
  final String label;
  final String text;

  const _SectionLabel({
    required this.icon,
    required this.label,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: AppColors.primarySoft,
            borderRadius: BorderRadius.circular(9),
          ),
          child: Icon(icon, size: 15, color: AppColors.primaryDeep),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                text,
                style: const TextStyle(
                  color: AppColors.inkSoft,
                  fontSize: 11.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
