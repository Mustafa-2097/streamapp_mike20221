import 'package:intl/intl.dart';

class CustomerProfile {
  final String id;
  final String email;
  final String role;
  final bool isVerified;
  final String? name;
  final String? profilePhoto; // Previously profileImage
  final String? dateOfBirth;
  final String? country;
  final String? status;
  final Subscription? subscription;
  final String? stripeCustomerId;
  
  bool get isPremiumUser {
    if (subscription == null) return false;
    if (subscription!.status.toLowerCase() != 'active') return false;
    return subscription!.plan?.type.toLowerCase() == 'premium' || 
           subscription!.plan?.type.toLowerCase() == 'superfan';
  }

  /*
  final String? phone;
  final String? gender;
  final String? profileImage;
  */

  CustomerProfile({
    required this.id,
    required this.email,
    required this.role,
    required this.isVerified,
    this.name,
    this.profilePhoto,
    this.dateOfBirth,
    this.country,
    this.status,
    this.subscription,
    this.stripeCustomerId,

    /*
    this.phone,
    this.gender,
    this.profileImage,
    */
  });

  factory CustomerProfile.fromJson(Map<String, dynamic> json) {
    String? photoUrl = json['profilePhoto']?.toString() ?? json['profileImage']?.toString();
    if (photoUrl != null) {
      // Robust replacement for localhost/127.0.0.1 with the server IP
      photoUrl = photoUrl
          .replaceAll('localhost', '10.0.30.59')
          .replaceAll('127.0.0.1', '10.0.30.59');
    }

    return CustomerProfile(
      id: json['id']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      role: json['role']?.toString() ?? '',
      isVerified: json['isVerified'] ?? false,
      name: json['name']?.toString(),
      profilePhoto: photoUrl,
      dateOfBirth: json['dateOfBirth']?.toString(),
      country: json['country']?.toString(),
      status: json['status']?.toString(),
      subscription: json['subscription'] != null
          ? Subscription.fromJson(json['subscription'])
          : null,
      stripeCustomerId: json['stripeCustomerId']?.toString(),

      /*
      phone: json['phone'],
      gender: json['gender'],
      profileImage: json['profileImage'],
      */
    );
  }
}

class Subscription {
  final String id;
  final String planId;
  final String status;
  final String? startDate;
  final String? endDate;
  final Plan? plan;

  Subscription({
    required this.id,
    required this.planId,
    required this.status,
    this.startDate,
    this.endDate,
    this.plan,
  });

  factory Subscription.fromJson(Map<String, dynamic> json) {
    return Subscription(
      id: json['id']?.toString() ?? '',
      planId: json['planId']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      startDate: json['startDate']?.toString() ?? json['startedAt']?.toString(),
      endDate: json['endDate']?.toString() ?? json['expiresAt']?.toString() ?? json['endsAt']?.toString(),
      plan: json['plan'] != null ? Plan.fromJson(json['plan']) : null,
    );
  }

  String get formattedEndDate {
    if (endDate == null || endDate!.isEmpty) return "N/A";
    try {
      final date = DateTime.parse(endDate!).toLocal();
      return DateFormat('dd/MM/yyyy').format(date);
    } catch (e) {
      return endDate!;
    }
  }
}

class Plan {
  final String id;
  final String name;
  final String type;
  final double price;
  final String billingCycle;
  final String description;
  final List<String> features;

  Plan({
    required this.id,
    required this.name,
    required this.type,
    required this.price,
    required this.billingCycle,
    required this.description,
    required this.features,
  });

  factory Plan.fromJson(Map<String, dynamic> json) {
    return Plan(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      billingCycle: json['billingCycle']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      features: List<String>.from(json['features'] ?? []),
    );
  }
}
