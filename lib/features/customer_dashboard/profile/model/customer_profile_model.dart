class CustomerProfile {
  final String id;
  final String email;
  final String role;
  final bool isVerified;
  final String? name;
  final String? phone;
  final String? gender;
  final String? profileImage;

  CustomerProfile({
    required this.id,
    required this.email,
    required this.role,
    required this.isVerified,
    this.name,
    this.phone,
    this.gender,
    this.profileImage,
  });

  factory CustomerProfile.fromJson(Map<String, dynamic> json) {
    return CustomerProfile(
      id: json['_id'],
      email: json['email'],
      role: json['role'],
      isVerified: json['isVerified'],
      name: json['name'],
      phone: json['phone'],
      gender: json['gender'],
      profileImage: json['profileImage'],
    );
  }
}
