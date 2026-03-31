import '../../core/network/api_endpoints.dart';

class UrlHelper {
  static String sanitizeUrl(String url) {
    if (url.isEmpty || url == "null") return "";
    
    // Get the base domain from ApiEndpoints.baseUrl
    // baseUrl is expected to be 'https://domain.com/api/v1' or 'http://ip:port/api/v1'
    final String base = ApiEndpoints.baseUrl.split('/api/v1')[0];
    
    // Extract domain from base (e.g. mike20221.smtsigma.com)
    final String baseDomain = base.replaceFirst('https://', '').replaceFirst('http://', '');
    
    // Check if the URL already has a domain that looks like the current base
    // If it's already a full URL with a proper domain, just return it sanitized for scheme
    if (url.startsWith('http') && !url.contains('localhost') && !url.contains('127.0.0.1') && !url.contains('10.0.30.59')) {
       // Just ensure scheme parity (if we are on https, use https)
       if (base.startsWith('https://') && url.startsWith('http://')) {
          return url.replaceFirst('http://', 'https://');
       }
       return url;
    }

    String sanitized = url
        .replaceAll('localhost:8000', baseDomain)
        .replaceAll('127.0.0.1:8000', baseDomain)
        .replaceAll('10.0.30.59:8000', baseDomain)
        .replaceAll('localhost', baseDomain)
        .replaceAll('127.0.0.1', baseDomain)
        .replaceAll('10.0.30.59', baseDomain);

    // Handle relative paths
    if (!sanitized.startsWith('http')) {
      if (sanitized.startsWith('/')) {
        sanitized = '$base$sanitized'.replaceAll('/api/v1/', '/');
      } else {
        sanitized = '$base/$sanitized'.replaceAll('/api/v1/', '/');
      }
    }
    
    // Ensure scheme parity
    if (base.startsWith('https://') && sanitized.startsWith('http://')) {
       sanitized = sanitized.replaceFirst('http://', 'https://');
    }

    return sanitized;
  }
}
