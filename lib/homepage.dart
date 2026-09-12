// lib/homepage.dart
// Halaman utama aplikasi: menampilkan daftar artikel, fitur pencarian,
// dan penyaringan berdasarkan kategori. Artikel paling atas tampil
// sebagai "Featured" (kartu besar), sisanya tampil sebagai kartu kecil.
import 'package:flutter/material.dart';
import 'models/post.dart';
import 'pages/detailpages.dart';
import 'pages/tambahpost.dart';
import 'theme.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Daftar artikel yang ditampilkan.
  // TODO: ganti dengan hasil GET /posts dari REST API saat backend siap.
  List<Post> posts = List.from(dummyPosts);

  // Kategori yang sedang dipilih (nilai awal: semua artikel).
  String selectedCategory = 'Semua';

  // Kata kunci pencarian yang diketik user.
  String _query = '';

  // Daftar kategori unik dari semua artikel + "Semua".
  List<String> get categories {
    final cats = posts.map((p) => p.category).toSet().toList();
    return ['Semua', ...cats];
  }

  // Artikel yang tampil setelah 2 tahap penyaringan:
  // 1. Filter berdasarkan kategori yang dipilih.
  // 2. Filter berdasarkan kata kunci pencarian (judul/ringkasan/penulis).
  List<Post> get filteredPosts {
    final q = _query.trim().toLowerCase();
    final byCategory = selectedCategory == 'Semua'
        ? posts
        : posts.where((p) => p.category == selectedCategory).toList();
    if (q.isEmpty) return byCategory;
    return byCategory
        .where((p) =>
            p.title.toLowerCase().contains(q) ||
            p.excerpt.toLowerCase().contains(q) ||
            p.author.toLowerCase().contains(q))
        .toList();
  }

  // ID postingan baru = ID terbesar di daftar + 1, agar tidak bentrok.
  int get _nextPostId {
    int maxId = 0;
    for (final post in posts) {
      if ((post.id ?? 0) > maxId) maxId = post.id ?? 0;
    }
    return maxId + 1;
  }

  // Membuka halaman detail artikel.
  // Saat kembali, hasil navigasi dibaca untuk memperbarui daftar:
  // - hasil 'deleted'  => artikel dihapus.
  // - hasil berupa Post => artikel diedit (perbarui datanya).
  void _openDetail(Post post) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => DetailPage(post: post)),
    );
    if (result == 'deleted') {
      setState(() => posts.removeWhere((p) => p.id == post.id));
    } else if (result is Post) {
      setState(() {
        final index = posts.indexWhere((p) => p.id == result.id);
        if (index != -1) posts[index] = result;
      });
    }
  }

  // Membuka halaman form untuk membuat artikel baru.
  // Hasilnya berupa Post baru yang langsung ditambahkan di paling atas.
  void _openCreateForm() async {
    final newPost = await Navigator.push<Post>(
      context,
      MaterialPageRoute(builder: (_) => const TambahPostPage()),
    );
    if (newPost != null) {
      setState(() => posts.insert(0, newPost.copyWith(id: _nextPostId)));
    }
  }
  
  // Menyusun tampilan halaman:
  // header -> kolom pencarian -> chips kategori -> judul "Terbaru" ->
  // kartu featured (jika ada) -> daftar kartu artikel -> tombol menulis.
  @override
  Widget build(BuildContext context) {
    final list = filteredPosts;
    final featured = list.isNotEmpty ? list.first : null;
    final rest = list.length > 1 ? list.sublist(1) : <Post>[];

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          _buildHeader(),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
            child: _buildSearchField(),
          ),
          _buildCategoryChips(),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
            child: _buildSectionTitle(rest),
          ),
          if (featured != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: _FeaturedCard(post: featured, onTap: () => _openDetail(featured)),
            ),
          const SizedBox(height: 20),
          if (rest.isEmpty)
            const _EmptyState()
          else
            ...rest.map(
              (post) => Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                child: _PostCard(post: post, onTap: () => _openDetail(post)),
              ),
            ),
          const SizedBox(height: 96),
        ],
      ),
      floatingActionButton: _GradientFab(onPressed: _openCreateForm),
    );
  }

  // Header bergradasi berisi nama aplikasi dan tombol notifikasi.
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 18),
      decoration: const BoxDecoration(
        gradient: AppColors.brandGradient,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppColors.accent,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        'Bacain',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.3,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Cerita & ide untuk harimu',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.75),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.16),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.notifications_none_rounded,
                  color: Colors.white, size: 20),
            ),
          ],
        ),
      ),
    );
  }

  // Kolom pencarian; tombol "x" muncul saat ada teks untuk menghapus pencarian.
  Widget _buildSearchField() {
    return TextField(
      onChanged: (value) => setState(() => _query = value),
      style: const TextStyle(fontSize: 14.5),
      decoration: InputDecoration(
        hintText: 'Cari artikel, kategori, atau penulis...',
        prefixIcon: const Icon(Icons.search_rounded, color: AppColors.inkSoft, size: 20),
        suffixIcon: _query.isEmpty
            ? null
            : IconButton(
                icon: const Icon(Icons.close_rounded, size: 18, color: AppColors.inkSoft),
                onPressed: () => setState(() => _query = ''),
              ),
        prefixIconColor: AppColors.inkSoft,
      ),
    );
  }

  // Baris chips kategori yang bisa digeser (scroll horizontal).
  Widget _buildCategoryChips() {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: SizedBox(
        height: 36,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: categories.length,
          separatorBuilder: (_, _) => const SizedBox(width: 8),
          itemBuilder: (context, index) {
            final cat = categories[index];
            final isSelected = cat == selectedCategory;
            return GestureDetector(
              onTap: () => setState(() => selectedCategory = cat),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  gradient: isSelected
                      ? AppColors.brandGradient
                      : const LinearGradient(colors: [Colors.white, Colors.white]),
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : const [],
                ),
                child: Text(
                  cat,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : AppColors.inkSoft,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // Judul bagian "Terbaru" + jumlah artikel hasil filter.
  Widget _buildSectionTitle(List<Post> rest) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Expanded(
            child: Text(
              'Terbaru',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.4,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.surfaceMuted,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${filteredPosts.length} artikel',
              style: const TextStyle(color: AppColors.inkSoft, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}

// Tombol mengambang "Tulis" di pojok kanan bawah untuk membuat artikel.
class _GradientFab extends StatelessWidget {
  final VoidCallback onPressed;

  const _GradientFab({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: onPressed,
      icon: const Icon(Icons.edit_outlined, size: 18, color: Colors.white),
      label: const Text(
        'Tulis',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
      ),
      backgroundColor: AppColors.primaryDeep,
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    );
  }
}

// Kartu besar berisi artikel terbaru (paling atas), dengan gaya sesuai kategori.
class _FeaturedCard extends StatelessWidget {
  final Post post;
  final VoidCallback onTap;

  const _FeaturedCard({required this.post, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final style = categoryStyle(post.category);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 190,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: style.colors,
          ),
          boxShadow: [
            BoxShadow(
              color: style.colors.last.withValues(alpha: 0.4),
              blurRadius: 26,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Positioned(
              right: -18,
              bottom: -18,
              child: Icon(
                style.icon,
                size: 140,
                color: Colors.white.withValues(alpha: 0.16),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.55),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.22),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      post.category,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    post.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                      height: 1.25,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(
                        Icons.schedule_rounded,
                        size: 13,
                        color: Colors.white70,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${post.readMinutes} menit baca',
                        style: const TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Kartu kecil berisi satu artikel (penulis, judul, ringkasan, kategori).
class _PostCard extends StatelessWidget {
  final Post post;
  final VoidCallback onTap;

  const _PostCard({required this.post, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final style = categoryStyle(post.category);
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [AppColors.cardShadow],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          _AuthorAvatar(name: post.author),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              post.author,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.inkSoft,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        post.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          height: 1.25,
                          letterSpacing: -0.2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        post.excerpt,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.inkSoft.withValues(alpha: 0.9),
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: style.colors.first.withValues(alpha: 0.14),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  style.icon,
                                  size: 12,
                                  color: style.colors.last,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  post.category,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: style.colors.last,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          Icon(
                            Icons.schedule_rounded,
                            size: 13,
                            color: AppColors.inkSoft.withValues(alpha: 0.6),
                          ),
                          const SizedBox(width: 3),
                          Text(
                            '${post.readMinutes} mnt',
                            style: TextStyle(
                              fontSize: 11.5,
                              color: AppColors.inkSoft.withValues(alpha: 0.8),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 14),
                Container(
                  width: 86,
                  height: 86,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: style.colors,
                    ),
                  ),
                  child: Icon(
                    style.icon,
                    size: 30,
                    color: Colors.white.withValues(alpha: 0.85),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Bulatan warna berisi huruf awal nama penulis.
// Warna dihitung dari huruf nama, jadi tiap penulis dapat warna berbeda.
class _AuthorAvatar extends StatelessWidget {
  final String name;

  const _AuthorAvatar({required this.name});

  @override
  Widget build(BuildContext context) {
    final hue = (name.codeUnits.fold<int>(0, (a, b) => a + b) * 37) % 360;
    return Container(
      width: 24,
      height: 24,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            HSLColor.fromAHSL(1, hue.toDouble(), 0.65, 0.6).toColor(),
            HSLColor.fromAHSL(1, (hue + 40) % 360, 0.65, 0.45).toColor(),
          ],
        ),
        shape: BoxShape.circle,
      ),
      child: Text(
        name.isNotEmpty ? name[0].toUpperCase() : '?',
        style: const TextStyle(
          fontSize: 11,
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

// Tampilan saat tidak ada artikel yang cocok dengan pencarian/kategori.
class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.primarySoft,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(Icons.search_off_rounded, size: 30, color: AppColors.primary),
          ),
          const SizedBox(height: 14),
          const Text(
            'Tidak ada artikel yang cocok',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          Text(
            'Coba kata kunci lain atau kategori berbeda.',
            style: const TextStyle(color: AppColors.inkSoft, fontSize: 13),
          ),
        ],
      ),
    );
  }
}