import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:isar/isar.dart';
import './models/task.dart';
import './date_type.dart';

class AddTask extends StatefulWidget {
  const AddTask({super.key, required this.isar, required this.dateType});
  final Isar isar;
  final DateType dateType;

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  late String status;

  @override
  void initState() {
    super.initState();

    status = DateType.today == widget.dateType ? '今日' : '明日';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "$statusのタスクを追加する",
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: DateType.today == widget.dateType
            ? const Color(0xFF389764)
            : Colors.yellow.shade800,
      ),
      body: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'タスク',
                style: TextStyle(fontSize: 20),
              ),
              TextField(
                controller: titleController,
                style: const TextStyle(fontSize: 20),
                decoration: const InputDecoration(
                  hintText: '入力してください',
                ),
              ),
              const Gap(40),
              const Text(
                '説明',
                style: TextStyle(fontSize: 20),
              ),
              const Gap(10),
              TextField(
                controller: descriptionController,
                maxLines: 4,
                style: const TextStyle(fontSize: 20),
                decoration: const InputDecoration(
                  hintText: '説明を入力してください',
                  border: OutlineInputBorder(),
                ),
              ),
              const Gap(40),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FilledButton.icon(
        onPressed: () async {
          if (titleController.text == '') {
            return;
          }

          final currentDate = widget.dateType == DateType.today
              ? DateTime.now()
              : DateTime.now().add(const Duration(days: 1));

          final DateTime runDate =
              DateTime(currentDate.year, currentDate.month, currentDate.day);

          final task = Task()
            ..name = titleController.text
            ..description = descriptionController.text
            ..runDate = runDate
            ..createAt = DateTime.now();

          await widget.isar.writeTxn(() async {
            await widget.isar.tasks.put(task);
          });

          if (!mounted) return;
          Navigator.of(context).pop();
        },
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          backgroundColor: DateType.today == widget.dateType
              ? const Color(0xFF389764)
              : Colors.yellow.shade800,
        ),
        icon: const Icon(
          Icons.note_add_outlined,
          color: Colors.white,
          size: 36.0,
        ),
        label: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            '追加する',
            style: TextStyle(
              fontSize: 26,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
