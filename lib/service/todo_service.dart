import 'package:dio/dio.dart';
import 'package:flutter_edu/common/common_api.dart';
import 'package:flutter_edu/common/logger.dart';
import 'package:flutter_edu/utils/error_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

class TodoModel {
  final String todoId;
  final bool state;
  final String todo;
  final String created;

  TodoModel({
    required this.todoId,
    required this.state,
    required this.todo,
    required this.created,
  });

  @override
  String toString() {
    return 'TodoModel(todoId: $todoId, state: $state, todo: $todo, created: $created)';
  }
}

class Response {
  final bool status;
  final int statusCode;
  final String message;
  final List<TodoModel> data;

  Response({this.status = false, this.statusCode = 0, this.message = '', this.data = const []});
}

class TodoService {
  final dio = Dio(BaseOptions(baseUrl: CommonApi.todoEndpoint));

  /// 모든 할일 조회
  Future<Response> getTodos() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String token = prefs.getString('token') ?? '';
      dio.options.headers[HttpHeaders.authorizationHeader] = token;

      final response = await dio.get('/');
      logger.d('TodoService :: getTodos response: ${response.data}');
      if (response.statusCode != HttpStatus.ok) {
        throw AppError('할 일 목록을 가져오는데 실패했습니다.', statusCode: response.statusCode);
      }

      return Response(
        status: response.statusCode == HttpStatus.ok,
        statusCode: response.statusCode ?? 0,
        message: response.statusMessage ?? '',
        data: (response.data['data'] as List)
            .map((e) => TodoModel(
                  todoId: e['todo_id'],
                  state: e['state'],
                  todo: e['todo'],
                  created: e['created'],
                ))
            .toList(),
      );
    } on DioException catch (e) {
      throw AppError(e.response?.data['message'] ?? '네트워크 오류가 발생했습니다.', statusCode: e.response?.statusCode);
    } catch (e) {
      throw AppError('예상치 못한 오류가 발생했습니다.');
    }
  }

  /// 할일 추가
  Future<Response> addTodo(String todo) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token') ?? '';
    dio.options.headers[HttpHeaders.authorizationHeader] = token;

    final response = await dio.post('/', data: {
      'todo': todo,
    });

    logger.d('TodoService :: addTodo response: ${response.data}');

    return Response(
      status: response.statusCode == HttpStatus.ok,
      statusCode: response.statusCode ?? 0,
      message: response.statusMessage ?? '',
    );
  }

  /// 할일 수정
  Future<Response> updateTodo(String todoId, String todo, bool state) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token') ?? '';
    dio.options.headers[HttpHeaders.authorizationHeader] = token;

    final response = await dio.put('/$todoId', data: {
      'todo': todo,
      'state': state,
    });

    logger.d('TodoService :: updateTodo response: ${response.data}');

    return Response(
      status: response.statusCode == HttpStatus.ok,
      statusCode: response.statusCode ?? 0,
      message: response.statusMessage ?? '',
    );
  }

  /// 할일 삭제
  Future<Response> deleteTodo(String todoId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token') ?? '';
    dio.options.headers[HttpHeaders.authorizationHeader] = token;

    final response = await dio.delete('/$todoId');

    logger.d('TodoService :: deleteTodo response: ${response.data}');

    return Response(
      status: response.statusCode == HttpStatus.ok,
      statusCode: response.statusCode ?? 0,
      message: response.statusMessage ?? '',
    );
  }
}
