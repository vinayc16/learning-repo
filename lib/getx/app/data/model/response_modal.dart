class ApiResponse<T>{
  final bool success;
  final String message;
  final T? data;
  final int? statusCode;
  final Map<String, dynamic>?error;

  ApiResponse({
    required this.success,
    required this.message,
    this.data,
    this.statusCode,
    this.error,
});

  factory ApiResponse.success(T data,{String? message}) {
    return ApiResponse<T>(
      success: true,
      message: message ??"Success",
      data: data,
      statusCode: 200,
    );
  }

  factory ApiResponse.error(String message,{Map<String, dynamic>? error,int? statusCode}) {
    return ApiResponse<T>(
      success: false,
      message: message ??"Something went wrong",
      error: error,
      statusCode: statusCode,
    );
  }
}