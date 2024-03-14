import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo/models/todo.dart';

class DatabaseService {
  final _firestore = FirebaseFirestore.instance;

  late final CollectionReference todoRef;

  DatabaseService() {
    todoRef = _firestore.collection("todos").withConverter<Todo>(
          fromFirestore: (snapshots, _) => Todo.fromJson(snapshots.data()!),
          toFirestore: (todo, _) => todo.toJson(),
        );
  }

  Stream<QuerySnapshot> getTodo() {
    return todoRef.snapshots();
  }

  void addTodoToDatabase(Todo todo) async {
    todoRef.add(todo);
  }

  void updateTodo(String todoId, Todo todo) {
    todoRef.doc(todoId).update(todo.toJson());
  }

  void deleteTodo(String todoId) {
    todoRef.doc(todoId).delete();
  }
}
