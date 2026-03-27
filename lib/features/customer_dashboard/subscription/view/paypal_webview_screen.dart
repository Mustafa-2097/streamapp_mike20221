import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../../core/const/app_colors.dart';

class PaypalWebViewScreen extends StatefulWidget {
  final String approvalUrl;

  const PaypalWebViewScreen({super.key, required this.approvalUrl});

  @override
  State<PaypalWebViewScreen> createState() => _PaypalWebViewScreenState();
}

class _PaypalWebViewScreenState extends State<PaypalWebViewScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
            });
            _checkUrlForCompletion(url);
          },
          onNavigationRequest: (NavigationRequest request) {
            if (_checkUrlForCompletion(request.url)) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.approvalUrl));
  }

  bool _checkUrlForCompletion(String url) {
    // If the backend's configured return url contains success or cancel
    if (url.toLowerCase().contains('success')) {
      Get.back(result: true); // Payment successful
      return true;
    } else if (url.toLowerCase().contains('cancel')) {
      Get.back(result: false); // Payment cancelled 
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('PayPal Checkout', style: TextStyle(color: Colors.white, fontSize: 18)),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Get.back(result: false), // Dismissed by user
        ),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(color: AppColors.primaryColor),
            ),
        ],
      ),
    );
  }
}
