// lib/pages/detailpages.dart
// Halaman detail isi artikel. Menampilkan hero bergambar kategori,
// lalu kartu berisi judul, penulis, dan isi artikel.
// Di bawah ada tombol Edit dan Hapus.
import 'package:flutter/material.dart';
import '../models/post.dart';
import '../theme.dart';
import 'editpost.dart';

class DetailPage extends StatelessWidget {
  final Post post;

  const DetailPage({
    super.key,
    required this.post,
  });

  @override
  Widget build(BuildContext context) {
    // Gaya (warna + ikon) mengikuti kategori artikel.
    final style = categoryStyle(post.category);

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Column(
        children: [
          Expanded(
            child: CustomScrollView(
              slivers: [
                // Bagian atas yang bisa digulung (menyusut saat scroll).
                SliverAppBar(
                  pinned: true,
                  stretch: true,
                  expandedHeight: 260,
                  backgroundColor: style.colors.last,
                  foregroundColor: Colors.white,
                  surfaceTintColor: Colors.transparent,
                  title: const Text(
                    'Artikel',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.3,
                    ),
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                    background: _HeroBackground(style: style, post: post),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Transform.translate(
                    offset: const Offset(0, -28),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                      child: _ArticleCard(post: post),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Tombol Edit & Hapus di bagian bawah layar.
          _BottomBar(
            onEdit: () async {
              // Buka halaman edit; jika ada hasil, kembalikan ke halaman utama.
              final result = await Navigator.push<Post>(
                context,
                MaterialPageRoute(
                  builder: (_) => EditPostPage(post: post),
                ),
              );
              if (result != null && context.mounted) {
                Navigator.pop(context, result);
              }
            },
            onDelete: () => _confirmDelete(context, style),
          ),
        ],
      ),
    );
  }

  // Menampilkan dialog konfirmasi sebelum artikel dihapus.
  Future<void> _confirmDelete(BuildContext context, CategoryStyle style) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text(
          'Hapus artikel?',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
        ),
        content: const Text(
          'Artikel akan dihapus permanen dan tidak bisa dikembalikan.',
          style: TextStyle(color: AppColors.inkSoft, fontSize: 13.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Hapus',
              style: TextStyle(color: AppColors.danger, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      Navigator.pop(context, 'deleted');
    }
  }
}

// Latar bergradasi di bagian atas, berisi ikon besar dan label kategori.
class _HeroBackground extends StatelessWidget {
  final CategoryStyle style;
  final Post post;

  const _HeroBackground({required this.style, required this.post});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: style.colors,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -18,
            top: 60,
            child: Icon(
              style.icon,
              size: 180,
              color: Colors.white.withValues(alpha: 0.14),
            ),
          ),
          Positioned(
            left: 20,
            bottom: 64,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.22),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                post.category,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Kartu putih berisi judul, identitas penulis, dan isi artikel.
class _ArticleCard extends StatelessWidget {
  final Post post;

  const _ArticleCard({required this.post});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [AppColors.cardShadow],
      ),
      padding: const EdgeInsets.fromLTRB(22, 24, 22, 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            post.title,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _AuthorAvatar(name: post.author),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.author,
                      style: const TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      '${post.readMinutes} menit baca',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.inkSoft,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          const Divider(),
          const SizedBox(height: 22),
          Text(
            post.content,
            style: TextStyle(
              fontSize: 15.5,
              height: 1.8,
              color: AppColors.ink.withValues(alpha: 0.88),
            ),
          ),
        ],
      ),
    );
  }
}

// Bar kotak di bawah layar berisi tombol Edit dan Hapus.
class _BottomBar extends StatelessWidget {
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _BottomBar({required this.onEdit, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.line)),
        boxShadow: [
          BoxShadow(
            color: Color(0x1F1B1B2F),
            blurRadius: 20,
            offset: Offset(0, -6),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: onEdit,
                icon: const Icon(Icons.edit_outlined, size: 18),
                label: const Text('Edit'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: onDelete,
                icon: const Icon(Icons.delete_outline, size: 18),
                label: const Text('Hapus'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.danger,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Bulatan warna berisi huruf awal nama penulis (ukuran lebih besar).
class _AuthorAvatar extends StatelessWidget {
  final String name;

  const _AuthorAvatar({required this.name});

  @override
  Widget build(BuildContext context) {
    final hue = (name.codeUnits.fold<int>(0, (a, b) => a + b) * 37) % 360;
    return Container(
      width: 40,
      height: 40,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            HSLColor.fromAHSL(1, hue.toDouble(), 0.65, 0.6).toColor(),
            HSLColor.fromAHSL(1, (hue + 40) % 360, 0.65, 0.45).toColor(),
          ],
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Text(
        name.isNotEmpty ? name[0].toUpperCase() : '?',
        style: const TextStyle(
          fontSize: 16,
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}