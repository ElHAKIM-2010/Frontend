
// lib/models/post.dart
// Model data untuk satu artikel blog.

class Post {
  final int? id;
  final String title;
  final String content;
  final String excerpt;
  final String category;
  final String author;
  final int readMinutes;

  const Post({
    this.id,
    required this.title,
    required this.content,
    required this.excerpt,
    required this.category,
    required this.author,
    required this.readMinutes,
  });

  // Membuat salinan Post dengan sebagian data diubah.
  // Dipakai saat mengedit, agar data lama yang tidak diubah tetap sama.
  Post copyWith({
    int? id,
    String? title,
    String? content,
    String? excerpt,
    String? category,
    String? author,
    int? readMinutes,
  }) {
    return Post(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      excerpt: excerpt ?? this.excerpt,
      category: category ?? this.category,
      author: author ?? this.author,
      readMinutes: readMinutes ?? this.readMinutes,
    );
  }
}

// Data contoh yang tampil di halaman utama sebelum backend REST API siap.
final List<Post> dummyPosts = [
  const Post(
    id: 1,
    title: 'Belajar Flutter untuk Pemula',
    content:
        'Flutter adalah framework untuk membuat aplikasi mobile. '
        'Dengan Flutter, kita bisa membangun aplikasi menggunakan bahasa Dart. '
        'Pelajari widget, layout, dan navigasi untuk membuat aplikasi yang menarik.',
    excerpt: 'Mengenal dasar Flutter dan cara membuat aplikasi mobile.',
    category: 'Teknologi',
    author: 'Hakim',
    readMinutes: 5,
  ),
  const Post(
    id: 2,
    title: 'Tips Menjadi Programmer Hebat',
    content:
        'Menjadi programmer membutuhkan latihan yang konsisten. '
        'Mulailah dari dasar, pahami logika pemrograman, dan biasakan '
        'membuat project kecil untuk mengasah kemampuan.',
    excerpt: 'Kebiasaan sederhana untuk meningkatkan kemampuan coding.',
    category: 'Tips',
    author: 'Hakim',
    readMinutes: 4,
  ),
  const Post(
    id: 3,
    title: 'Pentingnya Membaca di Era Digital',
    content:
        'Membaca membantu kita mendapatkan pengetahuan dan inspirasi. '
        'Dengan teknologi digital, artikel dan buku dapat diakses dengan mudah '
        'kapan saja dan di mana saja.',
    excerpt: 'Manfaat membaca dan belajar melalui artikel digital.',
    category: 'Pendidikan',
    author: 'Hakim',
    readMinutes: 3,
  ),
];