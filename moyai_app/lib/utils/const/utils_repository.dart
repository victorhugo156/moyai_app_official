import 'package:http/http.dart' as http;
import '../../auth/model/auth_repository.dart';
import '../api_error_response.dart';

class UtilsRepository {
  static  Future<dynamic> retryHttpRequest({
    required http.Response res,
    required Future Function() func,
    required AuthRepository authRepository,
    int maxRetries = 1,
  }) async {
    int retryCount = 0;

    while (retryCount <= maxRetries) {
      if (res.statusCode == 401) {
        var status = await authRepository.refreshToken();
        if (status) {
          retryCount++;
          res = await func();
        } else {
          throw ApiErrorResponse(
              statusCode: 401,
              message: "Session Expired, Login again",
              success: false);
        }
      } else {
        break;
      }
    }
    return res;
  }
}