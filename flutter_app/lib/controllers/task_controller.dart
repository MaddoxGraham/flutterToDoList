import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/task_model.dart';

class TaskController {
  Future<List<Task>> fetchData() async {
    final response = await http.get(Uri.parse('http://127.0.0.1:8000/api/tasks'));
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body.map((dynamic item) => Task.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> addTask(String text, Function(List<Task>) updateTasks) async {
    final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/api/tasks'),
      body: {'text': text},
    );
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Failed to add task');
    } else {
      List<Task> newTasks = await fetchData();
      updateTasks(newTasks);
    }
  }

 Future<void> deleteTask(int id, Function(List<Task>) updateTasks) async {
  final response = await http.delete(
    Uri.parse('http://127.0.0.1:8000/api/tasks/$id'),
  );
  if (response.statusCode == 200) {
    List<Task> newTasks = await fetchData();
    updateTasks(newTasks);
  } else {
    throw Exception('Failed to delete task');
  }
}

Future<void> updateTask(int id, String newText, Function(List<Task>) updateTasks) async {
  final response = await http.put(
    Uri.parse('http://127.0.0.1:8000/api/tasks/$id'),
    body: {'text': newText},
  );
  if (response.statusCode == 200) {
    List<Task> newTasks = await fetchData();
    updateTasks(newTasks);
  } else {
    throw Exception('Failed to update task');
  }
}

}
