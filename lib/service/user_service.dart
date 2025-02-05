import 'dart:io';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class User {
  final String email;
  final String password;
  final String name;

  User({this.email = '', this.password = '', this.name = ''});
}

class Response {
  final bool status;
  final int statusCode;
  final String message;

  Response({this.status = false, this.statusCode = 0, this.message = ''});
}

class UserApiService {
  final dio = Dio(BaseOptions(
      baseUrl:
          //'https://w6r8ie8xr7.execute-api.ap-northeast-2.amazonaws.com/dev/users',
          'http://127.0.0.1:5000/users'));

  Future<Response> signin(User user) async {
    final response = await dio.post('/signin', data: {
      'email': user.email,
      'password': user.password,
    });

    // 로그인 성공 시
    if (response.statusCode == HttpStatus.ok && response.data['data'] != null) {
      // 토큰 저장
      SharedPreferences.getInstance().then(
          (prefs) => prefs.setString('token', response.data['data']['token']));
    } else {
      return Response(
        status: false,
        statusCode: response.statusCode ?? 0,
        message: response.data['message'],
      );
    }

    return Response(
      status: response.statusCode == HttpStatus.ok,
      statusCode: response.statusCode ?? 0,
      message: response.data['message'],
    );
  }
}
