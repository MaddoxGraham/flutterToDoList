import 'package:flutter/material.dart';
import '../controllers/task_controller.dart';
import '../models/task_model.dart';

class HomeView extends StatefulWidget {
  final String title;

  HomeView({Key? key, required this.title}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final TaskController _taskController = TaskController();
  List<Task> _tasks = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() async {
    try {
      _tasks = await _taskController.fetchData();
      setState(() {});
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView.builder(
        itemCount: _tasks.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_tasks[index].text),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    TextEditingController _updateController = TextEditingController();
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Update Task'),
                          content: TextField(
                            controller: _updateController,
                            decoration: InputDecoration(hintText: 'Enter new task text'),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () async {
                                await _taskController.updateTask(
                                  _tasks[index].id, 
                                  _updateController.text, 
                                  (newTasks) {
                                    setState(() {
                                      _tasks = newTasks;
                                    });
                                  }
                                );
                                Navigator.of(context).pop();
                              },
                              child: Text('Update'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () async {
                    await _taskController.deleteTask(_tasks[index].id, (newTasks) {
                      setState(() {
                        _tasks = newTasks;
                      });
                    });
                  },
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          TextEditingController _textController = TextEditingController();
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Add Task'),
                content: TextField(
                  controller: _textController,
                  decoration: InputDecoration(hintText: 'Enter task here'),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () async {
                      await _taskController.addTask(_textController.text, (newTasks) {
                        setState(() {
                          _tasks = newTasks;
                        });
                      });
                      Navigator.of(context).pop();
                    },
                    child: Text('Add'),
                  ),
                ],
              );
            },
          );
        },
        tooltip: 'Add Task',
        child: const Icon(Icons.add),
      ),
    );
  }
}
