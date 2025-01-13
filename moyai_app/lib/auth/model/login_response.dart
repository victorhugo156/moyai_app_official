
class ApiResponse<T> {
  final int statusCode;
  final T data;
  final String message;
  final bool success;

  ApiResponse({
    required this.statusCode,
    required this.data,
    required this.message,
    required this.success,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json, T Function(Map<String, dynamic>) fromJsonT) {
    return ApiResponse(
      statusCode: json['statusCode'],
      data: fromJsonT(json['data']),
      message: json['message'],
      success: json['success'],
    );
  }
}


class LoginResponseData {
  final String accessToken;
  final String refreshToken;

  LoginResponseData({
    required this.accessToken,
    required this.refreshToken,
  });
  factory LoginResponseData.fromJson(Map<String, dynamic> json) {
    return LoginResponseData(
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
    );
  }
}