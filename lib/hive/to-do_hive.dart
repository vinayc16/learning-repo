import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final Box box = Hive.box('todoBox');
  final TextEditingController controller = TextEditingController();

  void addTodo() {
    if (controller.text.isEmpty) return;

    box.add({
      'title': controller.text,
      'isCompleted': false,
    });

    controller.clear();
  }

  void toggleComplete(int index) {
    final todo = box.getAt(index);
    todo['isCompleted'] = !todo['isCompleted'];
    box.putAt(index, todo);
  }

  void deleteTodo(int index) {
    box.deleteAt(index);
  }

  void updateTodo(int index, String newTitle) {
    final todo = box.getAt(index);
    todo['title'] = newTitle;
    box.putAt(index, todo);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hive To-Do App')),
      body: ValueListenableBuilder(
        valueListenable: box.listenable(),
        builder: (context, Box box, _) {
          if (box.isEmpty) {
            return const Center(child: Text('No tasks yet'));
          }

          return ListView.builder(
            itemCount: box.length,
            itemBuilder:  (context, index) {
              final todo = box.getAt(index);

              return ListTile(
                leading: Checkbox(
                  value: todo['isCompleted'],
                  onChanged: (_) => toggleComplete(index),
                ),
                title: Text(
                  todo['title'],
                  style: TextStyle(
                    decoration: todo['isCompleted']
                        ? TextDecoration.lineThrough
                        : null,
                  ),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        controller.text = todo['title'];
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text('Update Task'),
                            content: TextField(controller: controller),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  updateTodo(index, controller.text);
                                  controller.clear();
                                  Navigator.pop(context);
                                },
                                child: const Text('Update'),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => deleteTodo(index),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text('Add Task'),
              content: TextField(controller: controller),
              actions: [
                TextButton(
                  onPressed: () {
                    addTodo();
                    Navigator.pop(context);
                  },
                  child: const Text('Add'),
                ),
              ],
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
