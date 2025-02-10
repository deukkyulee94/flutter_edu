import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

class TodoModel {
  final String todoId;
  bool state;
  String todo;
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

  Response(
      {this.status = false,
      this.statusCode = 0,
      this.message = '',
      this.data = const []});
}

class TodoService {
  final dio = Dio(BaseOptions(
      baseUrl:
          //'https://w6r8ie8xr7.execute-api.ap-northeast-2.amazonaws.com/dev/users',
          'http://127.0.0.1:5000/todos'));

  /// 모든 할일 조회
  Future<Response> getTodos() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token') ?? '';
    dio.options.headers[HttpHeaders.authorizationHeader] = token;

    final response = await dio.get('/');

    print('TodoService :: getTodos response: ${response.data}');

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
  }

  /// 할일 추가
  Future<Response> addTodo(String todo) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token') ?? '';
    dio.options.headers[HttpHeaders.authorizationHeader] = token;

    final response = await dio.post('/', data: {
      'todo': todo,
    });

    print('TodoService :: addTodo response: ${response.data}');

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

    print('TodoService :: updateTodo response: ${response.data}');

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

    print('TodoService :: deleteTodo response: ${response.data}');

    return Response(
      status: response.statusCode == HttpStatus.ok,
      statusCode: response.statusCode ?? 0,
      message: response.statusMessage ?? '',
    );
  }
}
