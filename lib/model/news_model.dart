class NewsModel {
  final String id;
  final String title;
  final String slug;
  final String summary;
  final String content;
  final String image;
  final String category;
  final List<String> tags;
  final String publishedAt;
  final int viewCount;
  final String author;

  NewsModel({
    required this.id,
    required this.title,
    required this.slug,
    required this.summary,
    required this.content,
    required this.image,
    required this.category,
    required this.tags,
    required this.publishedAt,
    required this.viewCount,
    required this.author,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      slug: json['slug'] ?? '',
      summary: json['summary'] ?? '',
      content: json['content'] ?? '',
      image: json['featured_image_url'] ?? '',
      category: json['category'] ?? '',
      tags: List<String>.from(json['tags'] ?? []),
      publishedAt: json['published_at'] ?? '',
      viewCount: json['view_count'] ?? 0,
      author: json['author_name'] ?? 'Unknown',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'slug': slug,
      'summary': summary,
      'content': content,
      'featured_image_url': image,
      'category': category,
      'tags': tags,
      'published_at': publishedAt,
      'view_count': viewCount,
      'author_name': author,
    };
  }

  factory NewsModel.empty() => NewsModel(
    id: '',
    title: '',
    slug: '',
    summary: '',
    content: '',
    image: '',
    category: '',
    tags: [],
    publishedAt: '',
    viewCount: 0,
    author: '',
  );
}
