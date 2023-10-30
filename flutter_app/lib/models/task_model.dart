class Task {
  final int id;
  final String text;

  Task({required this.id, required this.text});

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      text: json['text'],
    );
  }
}
