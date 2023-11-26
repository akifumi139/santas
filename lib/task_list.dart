import 'package:flutter/material.dart';
import './date_type.dart';

class TaskList extends StatefulWidget {
  const TaskList({super.key, required this.dateType});

  final DateType dateType;

  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  late List<String> tasks;
  late String status;

  @override
  void initState() {
    tasks = List<String>.generate(100, (index) => "task $index");
    switch (widget.dateType) {
      case DateType.yesterday:
        status = '昨日';
        break;
      case DateType.today:
        status = '今日';

        break;
      case DateType.tomorrow:
        status = '明日';
        break;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Container(
              color: widget.dateType == DateType.today
                  ? Colors.lightGreen.shade50
                  : widget.dateType == DateType.tomorrow
                      ? Colors.yellow.shade50
                      : Colors.grey.shade200,
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "$status${tasks[index]}",
                    style: const TextStyle(fontSize: 20),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 20, top: 4),
                    child: Text(
                      "タスクの内容",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
