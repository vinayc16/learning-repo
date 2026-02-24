/// API Constants and Endpoints
class ApiConstants {
  // Base URL
  static const String baseUrl = 'https://api.escuelajs.co/api/v1';

  // Products Endpoints
  static const String products = '/products';
  static const String categories = '/categories';

  // Product specific endpoints
  static String productById(int id) => '/products/$id';
  static String productBySlug(String slug) => '/products/slug/$slug';
  static String relatedProducts(int id) => '/products/$id/related';
  static String relatedProductsBySlug(String slug) =>
      '/products/slug/$slug/related';

  // Pagination
  static String productsWithPagination({int offset = 0, int limit = 10}) =>
      '/products?offset=$offset&limit=$limit';

  // Timeout durations
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
}
