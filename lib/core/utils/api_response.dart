/// Generic API Response wrapper class
class ApiResponse<T> {
  final bool success;
  final T? data;
  final String? message;
  final int? statusCode;
  final dynamic error;

  ApiResponse({
    required this.success,
    this.data,
    this.message,
    this.statusCode,
    this.error,
  });

  /// Success response
  factory ApiResponse.success({
    required T data,
    String? message,
    int? statusCode,
  }) {
    return ApiResponse(
      success: true,
      data: data,
      message: message ?? 'Success',
      statusCode: statusCode ?? 200,
    );
  }

  /// Error response
  factory ApiResponse.error({
    required String message,
    int? statusCode,
    dynamic error,
  }) {
    return ApiResponse(
      success: false,
      message: message,
      statusCode: statusCode,
      error: error,
    );
  }

  /// Loading state
  factory ApiResponse.loading() {
    return ApiResponse(
      success: false,
      message: 'Loading...',
    );
  }

  @override
  String toString() {
    return 'ApiResponse(success: $success, data: $data, message: $message, statusCode: $statusCode, error: $error)';
  }
}
