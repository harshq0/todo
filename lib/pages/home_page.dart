import 'package:flutter/material.dart';
import 'package:todo/models/todo.dart';
import 'package:todo/services/database_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController taskController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  final DatabaseService databaseService = DatabaseService();

  void addNewTask() async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: SizedBox(
              height: 100,
              child: Column(
                children: [
                  TextField(
                    controller: taskController,
                    decoration: const InputDecoration(
                      hintText: 'Task',
                    ),
                  ),
                  TextField(
                    controller: descriptionController,
                    decoration: const InputDecoration(
                      hintText: 'Description',
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(
                    width: 11,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Todo todo = Todo(
                        task: taskController.text,
                        isDone: false,
                        description: descriptionController.text,
                      );
                      databaseService.addTodoToDatabase(todo);
                      Navigator.pop(context);
                      taskController.clear();
                      descriptionController.clear();
                    },
                    child: const Text('Save'),
                  ),
                ],
              ),
            ],
          );
        });
  }

  void editTask(String todoId, Todo todo) async {
    taskController.text = todo.task;
    descriptionController.text = todo.description;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: SizedBox(
            height: 100,
            child: Column(
              children: [
                TextField(
                  controller: taskController,
                  decoration: const InputDecoration(
                    hintText: 'Task',
                  ),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    hintText: 'Description',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Todo updateTodo = todo.copyWith(
                      task: taskController.text,
                      description: descriptionController.text,
                    );
                    databaseService.updateTodo(todoId, updateTodo);
                    Navigator.pop(context);
                    taskController.clear();
                    descriptionController.clear();
                  },
                  child: const Text('Update'),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white10,
        title: const Text(
          'To Do List',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addNewTask,
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder(
        stream: databaseService.getTodo(),
        builder: (context, snapshot) {
          List todos = snapshot.data?.docs ?? [];
          if (todos.isEmpty) {
            return const Center(
              child: Text(
                'Add New Tasks',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
              ),
            );
          }
          return ListView.builder(
            itemCount: todos.length,
            itemBuilder: (context, index) {
              Todo todo = todos[index].data();
              String todoId = todos[index].id;
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                child: ListTile(
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Checkbox(
                        value: todo.isDone,
                        onChanged: (value) {
                          Todo updatedTodo = todo.copyWith(
                            isDone: !todo.isDone,
                          );
                          databaseService.updateTodo(todoId, updatedTodo);
                        },
                      ),
                      IconButton(
                        onPressed: () {
                          editTask(todoId, todo);
                        },
                        icon: const Icon(Icons.edit),
                      ),
                    ],
                  ),
                  tileColor: Colors.white10,
                  title: Text(
                    todo.task,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      decoration: todo.isDone
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                  subtitle: Text(
                    todo.description,
                    style: TextStyle(
                      decoration: todo.isDone
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                  onLongPress: () {
                    databaseService.deleteTodo(todoId);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
