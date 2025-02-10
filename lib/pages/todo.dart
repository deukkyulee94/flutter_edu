import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/todo_card.dart';
import '../service/todo_service.dart';

class Todo extends StatefulWidget {
  const Todo({super.key});

  @override
  State<Todo> createState() => _TodoState();
}

class _TodoState extends State<Todo> {
  String? token;
  String? name;
  List<TodoModel> todos = [];

  @override
  void initState() {
    super.initState();
    _loadToken();
    _loadTodos();
  }

  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('token');
      name = prefs.getString('name');
    });
  }

  Future<void> _loadTodos() async {
    final response = await TodoService().getTodos();
    print(response.data);

    if (response.status) {
      setState(() {
        todos = response.data;
      });
    } else {
      print(response.message);
    }
  }

  final Color gray = const Color.fromRGBO(217, 217, 217, 1);
  final Color textGray = const Color.fromRGBO(128, 128, 128, 1);
  final Color white = const Color.fromRGBO(255, 255, 255, 1);
  final Color green = const Color.fromRGBO(106, 202, 124, 1);
  final Color blue = const Color.fromRGBO(0, 33, 245, 1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          width: MediaQuery.of(context).size.width, // 화면 전체 너비 가져오기
          height: 80,
          decoration: BoxDecoration(
            color: gray,
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
            // 전체 body를 Expanded로 감싸기
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 180),
              child: Column(
                children: [
                  SizedBox(height: 85),
                  Expanded(
                    child: ListView.separated(
                      itemBuilder: (context, index) {
                        var todo = todos[index];
                        return TodoCard(
                          todoId: todo.todoId,
                          state: todo.state,
                          todo: todo.todo,
                          created: todo.created,
                          onUpdate: (String newTodo, bool state) async {
                            // async 추가
                            // setState 밖에서 비동기 작업 수행
                            final response = await TodoService()
                                .updateTodo(todo.todoId, newTodo, state);
                            if (response.status) {
                              // 성공 시 상태 업데이트
                              setState(() {
                                todos[index].todo = newTodo;
                              });
                            } else {
                              print(response.message);
                            }
                          },
                          onUpdateState: (String newTodo, bool state) async {
                            // async 추가
                            // setState 밖에서 비동기 작업 수행
                            final response = await TodoService()
                                .updateTodo(todo.todoId, newTodo, state);
                            if (response.status) {
                              // 성공 시 상태 업데이트
                              setState(() {
                                todos[index].state = state;
                              });
                            }
                          },
                          onDelete: (String todoId) async {
                            // async 추가
                            // setState 밖에서 비동기 작업 수행
                            final response =
                                await TodoService().deleteTodo(todo.todoId);
                            if (response.status) {
                              // 성공 시 상태 업데이트
                              setState(() {
                                todos.removeAt(index);
                              });
                            } else {
                              print(response.message);
                            }
                          },
                        );
                      },
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 10), // width를 height로 변경
                      itemCount: todos.length,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            // 추가 버튼을 Padding으로 감싸기
            padding: const EdgeInsets.only(right: 20, left: 180),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 1153,
                  height: 220,
                  decoration: BoxDecoration(
                    color: green,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 20),
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
                        SizedBox(height: 25),
                        Row(
                          children: [
                            SizedBox(width: 10),
                          ],
                        ),
                        TextField(
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: white,
                            border: OutlineInputBorder(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(10),
                              ),
                              borderSide: BorderSide(color: white),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(10),
                              ),
                              borderSide: BorderSide(color: white),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(10),
                              ),
                              borderSide: BorderSide(color: white),
                            ),
                          ),
                        ),
                        SizedBox(height: 25),
                      ],
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    // TODO: API 호출하여 todo 추가
                  },
                  icon: Icon(
                    Icons.add_circle_outline,
                    color: blue,
                    size: 96,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
