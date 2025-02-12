import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_edu/common/common_api.dart';
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
  final dio = Dio(BaseOptions(baseUrl: CommonApi.baseUrl + CommonApi.userEndpoint));

  Future<Response> signin(User user) async {
    print('UserService :: signin email: ${user.email} password: ${user.password}');

    final response = await dio.post('/signin', data: {
      'email': user.email,
      'password': user.password,
    });

    print('UserService :: signin response: ${response.data}');

    // 로그인 성공 시
    if (response.statusCode == HttpStatus.ok && response.data['data'] != null) {
      // 토큰 및 이름 저장
      SharedPreferences.getInstance().then((prefs) => {
            prefs.setString('token', response.data['data']['token']),
            prefs.setString('name', response.data['data']['name']),
          });

      return Response(
        status: response.statusCode == HttpStatus.ok,
        statusCode: response.statusCode ?? 0,
        message: response.data['message'],
      );
    } else {
      return Response(
        status: false,
        statusCode: response.statusCode ?? 0,
        message: response.data['message'],
      );
    }
  }

  Future<Response> signup(User user) async {
    print('UserService :: signup email: ${user.email} name: ${user.name} password: ${user.password}');

    final response = await dio.post('/signup', data: {
      'email': user.email,
      'name': user.name,
      'password': user.password,
    });

    print('UserService :: signup response: ${response.data}');

    // 회원가입 성공시
    if (response.statusCode == HttpStatus.ok && response.data['data'] != null) {
      return Response(
        status: true,
        statusCode: response.statusCode ?? 0,
        message: response.data['message'],
      );
    } else {
      return Response(
        status: false,
        statusCode: response.statusCode ?? 0,
        message: response.data['message'],
      );
    }
  }
}
