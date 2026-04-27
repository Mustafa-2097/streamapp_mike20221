import '../../core/network/api_endpoints.dart';

class UrlHelper {
  static String sanitizeUrl(String url) {
    if (url.isEmpty || url == "null") return "";
    
    // Get the base domain from ApiEndpoints.baseUrl
    // baseUrl is expected to be 'https://domain.com/api/v1' or 'http://ip:port/api/v1'
    final String base = ApiEndpoints.baseUrl.split('/api/v1')[0];
    
    // Extract domain from base (e.g. mike20221.smtsigma.com or 10.0.30.59:8000)
    final String baseDomain = base.replaceFirst('https://', '').replaceFirst('http://', '');
    
    // Check if the URL already has a domain that looks like the current base
    // If it's already a full URL with a proper domain, just return it sanitized for scheme
    if (url.startsWith('http') && 
        !url.contains('localhost') && 
        !url.contains('127.0.0.1') && 
        !url.contains('10.0.30.59')) {
       // Just ensure scheme parity (if we are on https, use https)
       if (base.startsWith('https://') && url.startsWith('http://')) {
          return url.replaceFirst('http://', 'https://');
       }
       return url;
    }

    String sanitized = url;

    // First replace IP:PORT combinations to avoid partial replacement later
    final List<String> localHosts = ['localhost:8000', '127.0.0.1:8000', '10.0.30.59:8000'];
    bool replacedWithPort = false;
    for (var host in localHosts) {
      if (sanitized.contains(host)) {
        sanitized = sanitized.replaceAll(host, baseDomain);
        replacedWithPort = true;
      }
    }

    // Only if we haven't replaced an IP:PORT combination, replace the bare IPs/hostnames
    // This prevents double-port issues like 10.0.30.59:8000 -> baseDomain:8000
    if (!replacedWithPort) {
      sanitized = sanitized
          .replaceAll('localhost', baseDomain)
          .replaceAll('127.0.0.1', baseDomain)
          .replaceAll('10.0.30.59', baseDomain);
    }

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
    } else if (base.startsWith('http://') && sanitized.startsWith('https://')) {
       sanitized = sanitized.replaceFirst('https://', 'http://');
    }

    return sanitized;
  }
}
