import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../service/todo_service.dart';

final todoProvider = StateNotifierProvider<TodoNotifier, List<TodoModel>>((ref) {
  return TodoNotifier();
});

class TodoNotifier extends StateNotifier<List<TodoModel>> {
  TodoNotifier() : super([]);

  Future<void> fetchTodos() async {
    final response = await TodoService().getTodos();
    if (response.status) {
      state = response.data;
    }
  }

  Future<void> addTodo(String todo) async {
    final response = await TodoService().addTodo(todo);
    if (response.status) {
      fetchTodos();
    }
  }

  Future<void> updateTodo(String todoId, String todo, bool todoState) async {
    final response = await TodoService().updateTodo(todoId, todo, todoState);
    if (response.status) {
      fetchTodos();
    }
  }

  Future<void> deleteTodo(String todoId) async {
    final response = await TodoService().deleteTodo(todoId);
    if (response.status) {
      fetchTodos();
    }
  }
}
