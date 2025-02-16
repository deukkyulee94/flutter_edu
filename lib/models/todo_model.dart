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

  factory TodoModel.fromJson(Map<String, dynamic> json) {
    return TodoModel(
      todoId: json['todo_id'],
      state: json['state'],
      todo: json['todo'],
      created: json['created'],
    );
  }
}
