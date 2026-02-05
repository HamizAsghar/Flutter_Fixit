class BookingModel {
  final String id;
  final String userId;
  final String providerId;
  final String serviceId;
  final String
  status; // 'pending', 'confirmed', 'in_progress', 'completed', 'cancelled'
  final DateTime scheduledDate;
  final String address;
  final String city;
  final double? latitude;
  final double? longitude;
  final double totalPrice;
  final String paymentStatus; // 'pending', 'paid', 'refunded'
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  BookingModel({
    required this.id,
    required this.userId,
    required this.providerId,
    required this.serviceId,
    required this.status,
    required this.scheduledDate,
    required this.address,
    required this.city,
    this.latitude,
    this.longitude,
    required this.totalPrice,
    this.paymentStatus = 'pending',
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      providerId: json['provider_id'] as String,
      serviceId: json['service_id'] as String,
      status: json['status'] as String? ?? 'pending',
      scheduledDate: DateTime.parse(json['scheduled_date'] as String),
      address: json['address'] as String,
      city: json['city'] as String,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      totalPrice: (json['total_price'] as num).toDouble(),
      paymentStatus: json['payment_status'] as String? ?? 'pending',
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'provider_id': providerId,
      'service_id': serviceId,
      'status': status,
      'scheduled_date': scheduledDate.toIso8601String(),
      'address': address,
      'city': city,
      'latitude': latitude,
      'longitude': longitude,
      'total_price': totalPrice,
      'payment_status': paymentStatus,
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  BookingModel copyWith({
    String? id,
    String? userId,
    String? providerId,
    String? serviceId,
    String? status,
    DateTime? scheduledDate,
    String? address,
    String? city,
    double? latitude,
    double? longitude,
    double? totalPrice,
    String? paymentStatus,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return BookingModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      providerId: providerId ?? this.providerId,
      serviceId: serviceId ?? this.serviceId,
      status: status ?? this.status,
      scheduledDate: scheduledDate ?? this.scheduledDate,
      address: address ?? this.address,
      city: city ?? this.city,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      totalPrice: totalPrice ?? this.totalPrice,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  bool get isPending => status == 'pending';
  bool get isConfirmed => status == 'confirmed';
  bool get isInProgress => status == 'in_progress';
  bool get isCompleted => status == 'completed';
  bool get isCancelled => status == 'cancelled';
  bool get isPaid => paymentStatus == 'paid';
}
