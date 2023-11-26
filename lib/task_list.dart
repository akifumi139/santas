import 'package:flutter/material.dart';
import './models/task.dart';
import './date_type.dart';

class TaskList extends StatelessWidget {
  const TaskList({
    super.key,
    required this.tasks,
    required this.dateType,
    required this.onUpdateStatus,
    required this.onDeleteTask,
  });
  final List<Task> tasks;

  final DateType dateType;
  final Function(int) onUpdateStatus;
  final Function(int) onDeleteTask;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.all(8),
          child: ListTile(
            leading: dateType == DateType.today
                ? GestureDetector(
                    onTap: () async {
                      await onUpdateStatus(tasks[index].id);
                    },
                    child: CircleAvatar(
                      child: Icon(
                        tasks[index].isCompleted
                            ? Icons.check
                            : Icons.check_box_outline_blank,
                        size: 30,
                      ),
                    ),
                  )
                : dateType == DateType.yesterday
                    ? CircleAvatar(
                        backgroundColor: Colors.black38,
                        child: Icon(
                          tasks[index].isCompleted
                              ? Icons.check
                              : Icons.check_box_outline_blank,
                          size: 30,
                        ),
                      )
                    : null,
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
