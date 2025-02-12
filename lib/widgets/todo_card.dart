import 'package:flutter/material.dart';
import 'package:flutter_edu/common/common_colors.dart';

class TodoCard extends StatefulWidget {
  const TodoCard({
    super.key,
    required this.todoId,
    required this.state,
    required this.todo,
    required this.created,
    required this.onUpdate,
    required this.onUpdateState,
    required this.onDelete,
  });

  final String todoId;
  final bool state;
  final String todo;
  final String created;
  final Function(String, bool) onUpdate;
  final Function(String, bool) onUpdateState;
  final Function(String) onDelete;
  @override
  State<TodoCard> createState() => _TodoCardState();
}

class _TodoCardState extends State<TodoCard> {
  late bool state;
  late bool isEditing;
  late final TextEditingController todoController;

  @override
  void initState() {
    super.initState();
    state = widget.state;
    isEditing = false;
    todoController = TextEditingController(text: widget.todo);
  }

  @override
  void dispose() {
    todoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      margin: const EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
        color: CommonColors.gray,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () => {
                    setState(() => state = !state),
                    widget.onUpdateState(widget.todo, state),
                  },
                  child: Icon(
                    state ? Icons.check_circle_outline : Icons.circle_outlined,
                    color: Colors.black,
                    size: 48,
                  ),
                ),
                const SizedBox(width: 30),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    isEditing
                        ? SizedBox(
                            width: 750,
                            height: 50,
                            child: TextField(
                              controller: todoController, // TextField에 TextEditingController 연결
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
                          )
                        : Text(
                            widget.todo,
                            style: TextStyle(
                              decoration: state ? TextDecoration.lineThrough : TextDecoration.none,
                              fontSize: 36,
                              fontWeight: FontWeight.w400,
                              color: state ? CommonColors.textGray : Colors.black,
                            ),
                          ),
                    Text(
                      '등록일시 : ${widget.created}',
                      style: TextStyle(
                        decoration: state ? TextDecoration.lineThrough : TextDecoration.none,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: state ? CommonColors.textGray : Colors.black,
                      ),
                    )
                  ],
                ),
              ],
            ),
            if (!state)
              Row(
                children: [
                  IconButton(
                    onPressed: () => {
                      if (isEditing)
                        {
                          widget.onUpdate(todoController.text, widget.state),
                          setState(() => isEditing = !isEditing),
                        }
                      else
                        {
                          setState(() => isEditing = !isEditing),
                        }
                    },
                    icon: Icon(
                      isEditing ? Icons.download : Icons.edit_outlined,
                      color: Colors.black,
                      size: 48,
                    ),
                  ),
                  const SizedBox(width: 20),
                  IconButton(
                    onPressed: () => {
                      widget.onDelete(widget.todoId),
                    },
                    icon: Icon(Icons.delete_outlined, color: Colors.black, size: 48),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
