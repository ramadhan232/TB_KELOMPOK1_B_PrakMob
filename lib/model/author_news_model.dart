class AuthorNewsModel {
  final String id;
  final String title;
  final String slug;
  final String summary;
  final String content;
  final String featuredImageUrl;
  final String category;
  final List<String> tags;
  final String publishedAt;
  final int viewCount;
  final String createdAt;
  final String updatedAt;
  final bool isPublished;

  AuthorNewsModel({
    required this.id,
    required this.title,
    required this.slug,
    required this.summary,
    required this.content,
    required this.featuredImageUrl,
    required this.category,
    required this.tags,
    required this.publishedAt,
    required this.viewCount,
    required this.createdAt,
    required this.updatedAt,
    required this.isPublished,
  });

  factory AuthorNewsModel.fromJson(Map<String, dynamic> json) {
    return AuthorNewsModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      slug: json['slug'] ?? '',
      summary: json['summary'] ?? '',
      content: json['content'] ?? '',
      featuredImageUrl: json['featured_image_url'] ?? '',
      category: json['category'] ?? '',
      tags: List<String>.from(json['tags'] ?? []),
      publishedAt: json['published_at'] ?? '',
      viewCount: json['view_count'] ?? 0,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      isPublished: json['isPublished'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'slug': slug,
      'summary': summary,
      'content': content,
      'featuredImageUrl': featuredImageUrl,
      'category': category,
      'tags': tags,
      'published_at': publishedAt,
      'isPublished': isPublished,
    };
  }
}
