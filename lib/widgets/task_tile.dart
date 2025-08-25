import 'package:flutter/material.dart';

class TaskTile extends StatelessWidget {
  final Map task;
  TaskTile({required this.task});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(task['title']),
      subtitle: Text(task['description'] ?? ''),
      trailing: Icon(
        task['isCompleted'] ? Icons.check_circle : Icons.circle_outlined,
        color: task['isCompleted'] ? Colors.green : Colors.grey,
      ),
    );
  }
}
