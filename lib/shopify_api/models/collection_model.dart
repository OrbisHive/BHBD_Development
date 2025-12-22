/// Collection Model
/// 
/// Represents a Shopify collection.
/// Collections group products together.

class CollectionModel {
  final String id;
  final String title;
  final String handle;
  final String? description;
  final String? descriptionHtml;
  final String? imageUrl;
  final String? imageAlt;
  final DateTime? updatedAt;

  CollectionModel({
    required this.id,
    required this.title,
    required this.handle,
    this.description,
    this.descriptionHtml,
    this.imageUrl,
    this.imageAlt,
    this.updatedAt,
  });

  /// Parse from GraphQL response
  factory CollectionModel.fromJson(Map<String, dynamic> json) {
    final node = json['node'] ?? json;
    final image = node['image'];

    return CollectionModel(
      id: node['id'] ?? '',
      title: node['title'] ?? '',
      handle: node['handle'] ?? '',
      description: node['description'],
      descriptionHtml: node['descriptionHtml'],
      imageUrl: image?['url'],
      imageAlt: image?['altText'],
      updatedAt: node['updatedAt'] != null 
          ? DateTime.parse(node['updatedAt']) 
          : null,
    );
  }

  /// Convert to JSON (for caching metadata only)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'handle': handle,
      'description': description,
      'imageUrl': imageUrl,
      'imageAlt': imageAlt,
    };
  }
}

