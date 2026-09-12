// lib/pages/post_form.dart
// Widget form yang dipakai bersama oleh halaman "Tulis Artikel" (tambah)
// dan "Edit Artikel". Karena fungsinya sama, cukup tulis satu kali.
import 'package:flutter/material.dart';
import '../models/post.dart';
import '../theme.dart';

class PostForm extends StatefulWidget {
  final String submitLabel;
  final Post? initialPost;
  final void Function(Post post) onSubmit;

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
  // Controller menyimpan isi tiap kolom input.
  late final TextEditingController _titleController;
  late final TextEditingController _contentController;
  late final TextEditingController _categoryController;
  late final TextEditingController _authorController;

  // Saat halaman dibuka:
  // - Untuk tambah (initialPost = null) => kolom dikosongkan.
  // - Untuk edit (initialPost berisi data) => kolom diisi dengan data lama.
  @override
  void initState() {
    super.initState();
    final post = widget.initialPost;
    _titleController = TextEditingController(text: post?.title ?? '');
    _contentController = TextEditingController(text: post?.content ?? '');
    _categoryController = TextEditingController(text: post?.category ?? '');
    _authorController = TextEditingController(text: post?.author ?? '');
  }

  // Controller harus dibersihkan agar tidak membocorkan memori.
  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _categoryController.dispose();
    _authorController.dispose();
    super.dispose();
  }

  // Perkiraan lama baca = jumlah kata dibagi 200 kata per menit.
  int get _readMinutes {
    final words = _contentController.text.trim().split(RegExp(r'\s+'));
    final minutes = (words.length / 200).ceil();
    return minutes < 1 ? 1 : minutes;
  }

  // Ringkasan (excerpt): 140 karakter pertama isi artikel.
  String get _excerpt {
    final plain = _contentController.text.replaceAll('\n', ' ').trim();
    return plain.length > 140 ? '${plain.substring(0, 140)}...' : plain;
  }

  // Dipanggil saat tombol submit ditekan.
  void _submit() {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();
    final category = _categoryController.text.trim();
    final author = _authorController.text.trim();

    // Validasi: semua kolom wajib diisi.
    if (title.isEmpty || content.isEmpty || category.isEmpty || author.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Semua kolom wajib diisi.')),
      );
      return;
    }

    final post = widget.initialPost?.copyWith(
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

    // Serahkan hasil ke halaman yang memanggil form (tambah/edit).
    widget.onSubmit(post);
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
            decoration: const InputDecoration(hintText: 'Contoh: Cara Membuat Kopi yang Enak'),
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
            decoration: const InputDecoration(hintText: 'Contoh: Teknologi, Tips, Pendidikan'),
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
            onPressed: _submit,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              backgroundColor: AppColors.primaryDeep,
              foregroundColor: Colors.white,
            ),
            child: Text(widget.submitLabel),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

// Label kecil berisi ikon + judul + keterangan di atas tiap kolom input.
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
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
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