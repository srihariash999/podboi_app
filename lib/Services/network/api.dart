import 'package:dio/dio.dart';
import 'package:podboi/Services/network/urls.dart';

class ApiService {
  final Dio _dio = Dio();

  Future<Response?> userLoginNetwork(
      {required String email, required String password}) async {
    try {
      Response response = await _dio.post(loginUrl, data: {
        "email": email,
        "password": password,
      });
      return response;
    } on DioException catch (e) {
      print(" an error occured while loggin in ");
      print(e.response?.data);
      return e.response;
    }
  }
}
