import 'package:intl/intl.dart';

class PaymentHistoryModel {
  final String id;
  final String transactionId;
  final double amount;
  final String status;
  final String createdAt;
  final String provider;

  PaymentHistoryModel({
    required this.id,
    required this.transactionId,
    required this.amount,
    required this.status,
    required this.createdAt,
    required this.provider,
  });

  factory PaymentHistoryModel.fromJson(Map<String, dynamic> json) {
    return PaymentHistoryModel(
      id: json['id']?.toString() ?? '',
      transactionId: json['transactionId']?.toString() ?? json['id']?.toString() ?? 'N/A',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      status: json['status']?.toString() ?? 'Completed',
      createdAt: json['createdAt']?.toString() ?? '',
      provider: _parseProvider(json),
    );
  }

  static String _parseProvider(Map<String, dynamic> json) {
    final prov = json['provider']?.toString() ?? json['paymentMethod']?.toString() ?? '';
    if (prov.isEmpty) return 'PayPal'; // default fallback
    return prov;
  }

  String get formattedAmount => '\$${amount.toStringAsFixed(2)}';

  String get formattedDate {
    if (createdAt.isEmpty) return 'Unknown Date';
    try {
      final date = DateTime.parse(createdAt).toLocal();
      return DateFormat('dd MMM yyyy hh:mm a').format(date);
    } catch (e) {
      return createdAt; // return raw if parsing fails
    }
  }

  String get title => 'Transfer from $provider';
}
