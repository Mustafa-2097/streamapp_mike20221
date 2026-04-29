
class UrlHelper {
  static String sanitizeUrl(String url, String baseUrl) {
    if (url.isEmpty || url == "null") return "";
    
    final String base = baseUrl.split('/api/v1')[0];
    final String baseDomain = base.replaceFirst('https://', '').replaceFirst('http://', '');
    
    String sanitized = url;

    if (sanitized.startsWith('undefined/')) {
      sanitized = sanitized.replaceFirst('undefined/', '/');
    }

    sanitized = sanitized
        .replaceAll('localhost', baseDomain)
        .replaceAll('127.0.0.1', baseDomain);

    if (!sanitized.startsWith('http')) {
      if (sanitized.startsWith('/')) {
        sanitized = '$base$sanitized'.replaceAll('/api/v1/', '/');
      } else {
        sanitized = '$base/$sanitized'.replaceAll('/api/v1/', '/');
      }
    }
    
    return sanitized;
  }
}

void main() {
  String baseUrl = 'https://mike20221.smtsigma.com/api/v1';
  
  print("Test 1 (relative): " + UrlHelper.sanitizeUrl('clips/video.mp4', baseUrl));
  print("Test 2 (undefined relative): " + UrlHelper.sanitizeUrl('undefined/clips/video.mp4', baseUrl));
  print("Test 3 (localhost): " + UrlHelper.sanitizeUrl('http://localhost:8000/clips/video.mp4', baseUrl));
  print("Test 4 (explicit IP): " + UrlHelper.sanitizeUrl('http://10.0.30.59:8000/clips/video.mp4', baseUrl));
}
