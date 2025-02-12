import 'package:flutter/material.dart';
import 'package:flutter_edu/common/common_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/todo_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/todo_provider.dart';
import '../utils/error_handler.dart';

class Todo extends ConsumerStatefulWidget {
  const Todo({super.key});

  @override
  ConsumerState<Todo> createState() => _TodoState();
}

class _TodoState extends ConsumerState<Todo> {
  String? token;
  String? name;
  String newTodo = '';
  late TextEditingController newTodoController;
  bool isShowAddTodo = false;

  @override
  void initState() {
    super.initState();
    _loadToken();
    Future.microtask(() => ref.read(todoProvider.notifier).fetchTodos());
    newTodoController = TextEditingController();
  }

  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('token');
      name = prefs.getString('name');
    });
  }

  @override
  Widget build(BuildContext context) {
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
      body: FutureBuilder(
        future: ref.read(todoProvider.notifier).fetchTodos(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            ErrorHandler.handleError(context, snapshot.error);
            return const Center(child: Text('데이터를 불러오는데 실패했습니다.'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final todos = ref.watch(todoProvider);

          return Column(
            children: [
              Expanded(
                // 전체 body를 Expanded로 감싸기
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 180),
                  child: Column(
                    children: [
                      SizedBox(height: 85),
                      Expanded(
                        child: ListView.separated(
                          itemBuilder: (context, index) {
                            final todo = todos[index];
                            return TodoCard(
                              todoId: todo.todoId,
                              state: todo.state,
                              todo: todo.todo,
                              created: todo.created,
                              onUpdate: (String newTodo, bool state) async {
                                await ref.read(todoProvider.notifier).updateTodo(todo.todoId, newTodo, state);
                              },
                              onUpdateState: (String newTodo, bool state) async {
                                await ref.read(todoProvider.notifier).updateTodo(todo.todoId, newTodo, state);
                              },
                              onDelete: (String todoId) async {
                                await ref.read(todoProvider.notifier).deleteTodo(todo.todoId);
                              },
                            );
                          },
                          separatorBuilder: (context, index) => const SizedBox(height: 10),
                          itemCount: todos.length,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // 할일 등록 영역
              Padding(
                // 추가 버튼을 Padding으로 감싸기
                padding: const EdgeInsets.only(right: 20, left: 180),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (isShowAddTodo)
                      Container(
                        width: 1153,
                        height: 160,
                        decoration: BoxDecoration(
                          color: CommonColors.green,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 70),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '할일 등록',
                                style: TextStyle(
                                  fontSize: 36,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    width: 850,
                                    height: 45,
                                    child: TextField(
                                      controller: newTodoController,
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: CommonColors.white,
                                        border: OutlineInputBorder(
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(10),
                                          ),
                                          borderSide: BorderSide(color: CommonColors.white),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(10),
                                          ),
                                          borderSide: BorderSide(color: CommonColors.white),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(10),
                                          ),
                                          borderSide: BorderSide(color: CommonColors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 50),
                                  IconButton(
                                    onPressed: () async {
                                      await ref.read(todoProvider.notifier).addTodo(newTodoController.text);
                                      setState(() {
                                        isShowAddTodo = false;
                                        newTodoController.clear();
                                      });
                                    },
                                    icon: Icon(
                                      Icons.download,
                                      color: Colors.black,
                                      size: 48,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    if (!isShowAddTodo)
                      SizedBox(
                        width: 100,
                        height: 160,
                      ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          isShowAddTodo = !isShowAddTodo;
                          newTodoController.clear();
                        });
                      },
                      icon: Icon(
                        Icons.add_circle_outline,
                        color: CommonColors.blue,
                        size: 96,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
