import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/todo_model.dart';
import '../services/todo_service.dart';

class TodoViewModel extends StateNotifier<List<TodoModel>> {
  final TodoService _todoService;

  TodoViewModel(this._todoService) : super([]);

  Future<List<TodoModel>> fetchTodos() async {
    try {
      final response = await _todoService.getTodos();
      state = response.data;
    } catch (e) {
      // 에러 처리
      state = [];
    }
  }

  Future<void> addTodo(String todo) async {
    try {
      await _todoService.addTodo(todo);
      await fetchTodos();
    } catch (e) {
      // 에러 처리
    }
  }

  Future<void> updateTodo(String todoId, String todo, bool todoState) async {
    try {
      await _todoService.updateTodo(todoId, todo, todoState);
      await fetchTodos();
    } catch (e) {
      // 에러 처리
    }
  }

  Future<void> deleteTodo(String todoId) async {
    try {
      await _todoService.deleteTodo(todoId);
      await fetchTodos();
    } catch (e) {
      // 에러 처리
    }
  }
}

final todoViewModelProvider = StateNotifierProvider<TodoViewModel, List<TodoModel>>((ref) {
  return TodoViewModel(TodoService());
});
