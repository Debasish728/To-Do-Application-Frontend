import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';
import '../widgets/task_tile.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> _tasks = [];
  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  void _loadTasks() async {
    try {
      final tasks = await ApiService.fetchTasks();
      setState(() => _tasks = tasks);
    } catch (e) {
      if (e.toString().contains('invalid token')) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => LoginScreen()),
        );
      } else {
        // Optionally handle other errors
        setState(() => _tasks = []);
      }
    }
  }

  void _logout() async {
    await AuthService.logOut();
    Navigator.push(context, MaterialPageRoute(builder: (_) => LoginScreen()));
  }

  void addTaskDialog() {
    final titleController = TextEditingController();
    final descController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Add Task"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(hintText: "Title"),
            ),
            TextField(
              controller: descController,
              decoration: InputDecoration(hintText: "Description"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              await ApiService.createTask(
                titleController.text,
                descController.text,
              );
              Navigator.pop(context);
              _loadTasks();
            },
            child: Text("Save"),
          ),
        ],
      ),
    );
  }

  void editTaskDialog(
    int taskId,
    String currentTitle,
    String currentDesc,
    bool currIsCompleted,
  ) {
    final titleController = TextEditingController(text: currentTitle);
    final descController = TextEditingController(text: currentDesc);
    bool isCompleted = currIsCompleted;

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        // allows updating inside dialog
        builder: (context, setState) {
          return AlertDialog(
            title: Text("Edit Task"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(hintText: "Title"),
                ),
                TextField(
                  controller: descController,
                  decoration: InputDecoration(hintText: "Description"),
                ),
                Row(
                  children: [
                    Text("Completed"),
                    Checkbox(
                      value: isCompleted,
                      onChanged: (val) {
                        setState(() {
                          isCompleted = val ?? false;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () async {
                  await ApiService.updateTask(
                    taskId,
                    titleController.text,
                    descController.text,
                    isCompleted,
                  );
                  Navigator.pop(context);
                  _loadTasks();
                },
                child: Text("Update"),
              ),
            ],
          );
        },
      ),
    );
  }

  void deleteTask(int taskId) async {
    await ApiService.deleteTask(taskId);
    _loadTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Tasks")),
      body: ListView.builder(
        itemCount: _tasks.length,
        itemBuilder: (context, index) {
          final task = _tasks[index];
          return ListTile(
            title: Text(task["title"]),
            subtitle: Text(task["description"]),
            
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  task['isCompleted']
                      ? Icons.check_circle
                      : Icons.circle_outlined,
                  color: task['isCompleted'] ? Colors.green : Colors.grey,
                ),
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.blue),
                  onPressed: () => editTaskDialog(
                    task["id"],
                    task["title"],
                    task["description"],
                    task["isCompleted"],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () => deleteTask(task["id"]),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addTaskDialog,
        child: Icon(Icons.add),
      ),
    );
  }
}
