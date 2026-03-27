import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:testapp/core/common/widgets/scaffold_bg.dart';
import 'package:get/get.dart';

import '../../../../../core/const/app_colors.dart';
import '../../../data/customer_api_service.dart';
import '../../model/payment_history_model.dart';

class PaymentHistoryPage extends StatefulWidget {
  const PaymentHistoryPage({super.key});

  @override
  State<PaymentHistoryPage> createState() => _PaymentHistoryPageState();
}

class _PaymentHistoryPageState extends State<PaymentHistoryPage> {
  List<PaymentHistoryModel> _history = [];
  bool _isLoading = true;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _fetchHistory();
  }

  Future<void> _fetchHistory() async {
    try {
      final profileResponse = await CustomerApiService.getProfile();
      final data = profileResponse['data'];
      if (data == null || data['id'] == null) {
        throw Exception('User ID not found');
      }

      final userId = data['id'].toString();

      final historyResponse = await CustomerApiService.getPaymentHistory(userId: userId);
      if (historyResponse['success'] == true) {
        final List list = (historyResponse['data'] ?? []) as List;
        if (mounted) {
          setState(() {
            _history = list.map((e) => PaymentHistoryModel.fromJson(e)).toList();
            _isLoading = false;
          });
        }
      } else {
        throw Exception(historyResponse['message'] ?? 'Failed to load history');
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString().replaceAll('Exception: ', '');
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.white),
        title: Text(
          "PAYMENT HISTORY",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
      body: ScaffoldBg(
        child: SafeArea(
          child: _buildBody(),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primaryColor),
      );
    }

    if (_error.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_error, style: TextStyle(color: Colors.white70, fontSize: 16.sp)),
            SizedBox(height: 16.h),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _isLoading = true;
                  _error = '';
                });
                _fetchHistory();
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryColor),
              child: const Text('Retry', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );
    }

    if (_history.isEmpty) {
      return Center(
        child: Text("No transaction history", style: TextStyle(color: Colors.white70, fontSize: 16.sp)),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      itemCount: _history.length,
      itemBuilder: (context, index) {
        return _buildHistoryCard(_history[index]);
      },
    );
  }

  Widget _buildHistoryCard(PaymentHistoryModel item) {
    // Basic dynamic logos based on provider string
    final providerLower = item.provider.toLowerCase();
    String logoPath = "assets/images/stripe.png"; // default
    if (providerLower.contains('paypal')) {
      logoPath = "assets/images/subscription_logo.png"; // reusing paypal/subscription logo
    }

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey.shade800,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Platform/Provider Logo Box
          Container(
            height: 52.r,
            width: 52.r,
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Image.asset(
              logoPath,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => Icon(Icons.payment, color: Colors.white),
            ),
          ),
          SizedBox(width: 10.w),
          
          // Details
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400, color: Colors.white),
                ),
                SizedBox(height: 10.h),
                Text(
                  "Transaction ID",
                  style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400, color: Colors.grey),
                ),
                Text(
                  item.transactionId,
                  style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400, color: Colors.grey),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          
          // Amount & Status
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                item.formattedAmount,
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600, color: Colors.white),
              ),
              SizedBox(height: 4.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6.r),
                  color: AppColors.primaryColor,
                ),
                child: Text(
                  item.status.toUpperCase(),
                  style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                item.formattedDate,
                style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w400, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
