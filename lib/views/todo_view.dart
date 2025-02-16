import 'package:flutter/material.dart';
import 'package:flutter_edu/common/common_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../viewmodels/todo_viewmodel.dart';
import '../widgets/todo_card.dart';

class TodoView extends ConsumerWidget {
  late TextEditingController newTodoController;
  bool isShowAddTodo = false;
  String? token;
  String? name;
  String newTodo = '';

  TodoView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todos = ref.watch(todoViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: Container(
          width: MediaQuery.of(context).size.width, // 화면 전체 너비 가져오기
          height: 80,
          decoration: BoxDecoration(
            color: CommonColors.gray,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(name ?? ''),
              ],
            ),
          ),
        ),
        automaticallyImplyLeading: false, // 뒤로가기 버튼 제거
      ),
      body: Column(
        children: [
          Expanded(
            child: todos.isEmpty
                ? CircularProgressIndicator()
                : ListView.builder(
                    itemCount: todos.length,
                    itemBuilder: (context, index) {
                      final todo = todos[index];
                      return TodoCard(
                        todoId: todo.todoId,
                        state: todo.state,
                        todo: todo.todo,
                        created: todo.created,
                        onUpdate: (String newTodo, bool state) {
                          ref.read(todoViewModelProvider.notifier).updateTodo(todo.todoId, newTodo, state);
                        },
                        onDelete: (String todoId) {
                          ref.read(todoViewModelProvider.notifier).deleteTodo(todo.todoId);
                        },
                        onUpdateState: (String, bool) {},
                      );
                    },
                  ),
          ),
          // 할일 추가 UI 부분
        ],
      ),
    );
  }
}
