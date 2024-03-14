class Todo {
  String task;
  String description;
  bool isDone;

  Todo({
    required this.task,
    required this.description,
    required this.isDone,
  });

  Todo.fromJson(Map<String, dynamic> json)
      : task = json['task'] ?? '',
        description = json['description'] ?? '',
        isDone = json['isDone'] ?? false;

  Todo copyWith({
    String? task,
    String? description,
    bool? isDone,
  }) {
    return Todo(
      task: task ?? this.task,
      description: description ?? this.description,
      isDone: isDone ?? this.isDone,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'task': task,
      'description': description,
      'isDone': isDone,
    };
  }
}
