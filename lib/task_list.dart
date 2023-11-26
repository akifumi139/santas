import 'package:flutter/material.dart';
import './models/task.dart';
import './date_type.dart';

class TaskList extends StatelessWidget {
  const TaskList({super.key, required this.tasks, required this.dateType});
  final List<Task> tasks;

  final DateType dateType;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Container(
            color: dateType == DateType.today
                ? Colors.lightGreen.shade50
                : dateType == DateType.tomorrow
                    ? Colors.yellow.shade50
                    : Colors.grey.shade200,
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tasks[index].name,
                  style: const TextStyle(fontSize: 20),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, top: 4),
                  child: Text(
                    tasks[index].description,
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
