
class ApiErrorResponse {
  final int statusCode;
  final String message;
  final Map<String, dynamic>? error;
  final bool success;

  ApiErrorResponse({
    required this.statusCode,
    required this.message,
    this.error,
    required this.success,
  });

  factory ApiErrorResponse.fromJson(Map<String, dynamic> json) {
    return ApiErrorResponse(
      statusCode: json['statusCode'],
      message: json['message'],
      error: json['error'] != null ? Map<String, dynamic>.from(json['error']) : null,
      success: json['success'],
    );
  }
}
