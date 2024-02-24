/// Blog Post Data Type Definition
class BlogPost {
  const BlogPost({
    required this.id,
    required this.image,
    required this.title,
    required this.slug,
    required this.date,
    required this.excerpt,
    required this.body,
  });
  final int id;
  final String image;
  final String title;
  final String slug;
  final String date;
  final String excerpt;
  final String body;
  factory BlogPost.fromJson(Map<String, dynamic> json) {
    return BlogPost(
        id: json['id'],
        image: json['featured_image'],
        title: json['title'],
        slug: json['slug'],
        date: json['modified_date'],
        excerpt: json['excerpt'],
        body: json['body']);
  }
}
