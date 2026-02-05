class ServiceModel {
  final String id;
  final String categoryId;
  final String providerId;
  final String name;
  final String? description;
  final double basePrice;
  final int? durationMinutes;
  final String? imageUrl;
  final bool isActive;
  final double rating;
  final int totalBookings;
  final DateTime createdAt;
  final DateTime updatedAt;

  ServiceModel({
    required this.id,
    required this.categoryId,
    required this.providerId,
    required this.name,
    this.description,
    required this.basePrice,
    this.durationMinutes,
    this.imageUrl,
    this.isActive = true,
    this.rating = 0.0,
    this.totalBookings = 0,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id'] as String,
      categoryId: json['category_id'] as String,
      providerId: json['provider_id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      basePrice: (json['base_price'] as num).toDouble(),
      durationMinutes: json['duration_minutes'] as int?,
      imageUrl: json['image_url'] as String?,
      isActive: json['is_active'] as bool? ?? true,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      totalBookings: json['total_bookings'] as int? ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category_id': categoryId,
      'provider_id': providerId,
      'name': name,
      'description': description,
      'base_price': basePrice,
      'duration_minutes': durationMinutes,
      'image_url': imageUrl,
      'is_active': isActive,
      'rating': rating,
      'total_bookings': totalBookings,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  ServiceModel copyWith({
    String? id,
    String? categoryId,
    String? providerId,
    String? name,
    String? description,
    double? basePrice,
    int? durationMinutes,
    String? imageUrl,
    bool? isActive,
    double? rating,
    int? totalBookings,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ServiceModel(
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,
      providerId: providerId ?? this.providerId,
      name: name ?? this.name,
      description: description ?? this.description,
      basePrice: basePrice ?? this.basePrice,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      imageUrl: imageUrl ?? this.imageUrl,
      isActive: isActive ?? this.isActive,
      rating: rating ?? this.rating,
      totalBookings: totalBookings ?? this.totalBookings,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
