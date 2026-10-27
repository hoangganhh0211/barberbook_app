class ServiceAdminItem {
  const ServiceAdminItem({
    required this.id,
    required this.shopId,
    required this.name,
    required this.price,
    required this.durationMinutes,
    required this.isActive,
    this.description,
    this.imageUrl,
  });

  final String id;
  final String shopId;
  final String name;
  final String? description;
  final double price;
  final int durationMinutes;
  final String? imageUrl;
  final bool isActive;

  factory ServiceAdminItem.fromJson(Map<String, dynamic> json) {
    return ServiceAdminItem(
      id: json['id'] as String,
      shopId: json['shop_id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      price: (json['price'] as num).toDouble(),
      durationMinutes: (json['duration_minutes'] as num).toInt(),
      imageUrl: json['image_url'] as String?,
      isActive: json['is_active'] as bool? ?? true,
    );
  }
}

class ServiceFormData {
  const ServiceFormData({
    required this.name,
    required this.price,
    required this.durationMinutes,
    this.description,
    this.imageUrl,
  });

  final String name;
  final String? description;
  final int price;
  final int durationMinutes;
  final String? imageUrl;
}
