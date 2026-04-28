import '../../core/network/api_endpoints.dart';

class UrlHelper {
  static String sanitizeUrl(String url) {
    if (url.isEmpty || url == "null") return "";
    
    final String base = ApiEndpoints.baseUrl.split('/api/v1')[0];
    final String baseDomain = base.replaceFirst('https://', '').replaceFirst('http://', '');
    
    String sanitized = url;

    // Handle 'undefined/' prefix
    if (sanitized.startsWith('undefined/')) {
      sanitized = sanitized.replaceFirst('undefined/', '/');
    }

    // Replace loopback addresses with the base domain or IP
    sanitized = sanitized
        .replaceAll('localhost', baseDomain)
        .replaceAll('127.0.0.1', baseDomain);

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
       // Only replace if it's the same domain
       if (sanitized.contains(baseDomain)) {
         sanitized = sanitized.replaceFirst('http://', 'https://');
       }
    } else if (base.startsWith('http://') && sanitized.startsWith('https://')) {
       if (sanitized.contains(baseDomain)) {
         sanitized = sanitized.replaceFirst('https://', 'http://');
       }
    }

    // Final cleanup: remove double slashes (except after protocol)
    sanitized = sanitized.split('://').map((part) {
      if (part.contains('/')) {
        return part.replaceAll('//', '/');
      }
      return part;
    }).join('://');

    return sanitized;
  }
}
