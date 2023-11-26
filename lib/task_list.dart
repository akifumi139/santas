import 'package:flutter/material.dart';
import './models/task.dart';
import './date_type.dart';

class TaskList extends StatelessWidget {
  const TaskList(
      {super.key,
      required this.tasks,
      required this.dateType,
      required this.onDeleteTask});
  final List<Task> tasks;

  final DateType dateType;
  final Function(int) onDeleteTask;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.all(8),
          child: ListTile(
            tileColor: dateType == DateType.today
                ? Colors.lightGreen.shade50
                : dateType == DateType.tomorrow
                    ? Colors.yellow.shade50
                    : Colors.grey.shade200,
            title: Container(
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
            trailing: IconButton(
              icon: const Icon(
                Icons.delete,
                color: Colors.black45,
                size: 32,
              ),
              onPressed: () async {
                await onDeleteTask(tasks[index].id);
              },
            ),
          ),
        );
      },
    );
  }
}
