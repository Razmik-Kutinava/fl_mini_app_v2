class Order {
  final String id;
  final String locationId;
  final List<Map<String, dynamic>> items;
  final String? promoCode;
  final double total;
  final String status;
  final DateTime createdAt;

  Order({
    required this.id,
    required this.locationId,
    required this.items,
    this.promoCode,
    required this.total,
    required this.status,
    required this.createdAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] as String,
      locationId: json['locationId'] as String,
      items: (json['items'] as List<dynamic>).cast<Map<String, dynamic>>(),
      promoCode: json['promoCode'] as String?,
      total: (json['total'] as num).toDouble(),
      status: json['status'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}
