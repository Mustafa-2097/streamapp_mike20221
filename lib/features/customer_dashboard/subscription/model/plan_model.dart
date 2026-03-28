class PlanModel {
  final String id;
  final String name;
  final String type;
  final double price;
  final String billingCycle;
  final String? description;
  final List<String> features;
  final String? paypalPlanId;
  final String? createdAt;
  final String? updatedAt;

  PlanModel({
    required this.id,
    required this.name,
    required this.type,
    required this.price,
    required this.billingCycle,
    this.description,
    required this.features,
    this.paypalPlanId,
    this.createdAt,
    this.updatedAt,
  });

  factory PlanModel.fromJson(Map<String, dynamic> json) {
    return PlanModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      billingCycle: json['billingCycle']?.toString() ?? '',
      description: json['description']?.toString(),
      features: (json['features'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      paypalPlanId: json['paypalPlanId']?.toString(),
      createdAt: json['createdAt']?.toString(),
      updatedAt: json['updatedAt']?.toString(),
    );
  }

  /// Formatted price string e.g. "\$4.99"
  String get formattedPrice => price == 0 ? 'Free' : '\$${price.toStringAsFixed(2)}';

  /// Billing label e.g. "/month", "/year", or "" for free
  String get billingLabel {
    switch (billingCycle.toUpperCase()) {
      case 'MONTHLY':
        return '/month';
      case 'YEARLY':
        return '/year';
      case 'INFINITE':
        return '';
      default:
        return '';
    }
  }

  /// Whether this is the free plan
  bool get isFree => type.toUpperCase() == 'FREE';

  /// Whether this is a premium plan
  bool get isPremium => type.toUpperCase() == 'PREMIUM';

  /// Whether this is a superfan plan
  bool get isSuperfan => type.toUpperCase() == 'SUPERFAN';
}
