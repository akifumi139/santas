import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:isar/isar.dart';
import './models/task.dart';
import './task_list.dart';
import './date_type.dart';
import './add_task.dart';
import './empty_app_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.isar});
  final Isar isar;

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late DateTime selectedDate;
  late DateType tabStatus;

  List<Task> todayTaskList = [];
  List<Task> yesterdayTaskList = [];
  List<Task> tomorrowTaskList = [];

  @override
  void initState() {
    _tabController = TabController(
      length: 3,
      initialIndex: 1,
      vsync: this,
    );

    initLoad();
    _tabController.addListener(() {
      loadTasks();
    });

    super.initState();
  }

  Future<void> initLoad() async {
    final DateTime yesterday = DateTime.now().subtract(const Duration(days: 1));
    final DateTime today = DateTime.now();
    final DateTime tomorrow = DateTime.now().add(const Duration(days: 1));

    tabStatus = DateType.today;
    selectedDate = DateTime(today.year, today.month, today.day);

    final tasksList = [
      await getTaskList(yesterday),
      await getTaskList(today),
      await getTaskList(tomorrow)
    ];

    setState(() {
      yesterdayTaskList = tasksList[0];
      todayTaskList = tasksList[1];
      tomorrowTaskList = tasksList[2];
    });
  }

  Future<void> loadTasks() async {
    switch (_tabController.index) {
      case 0:
        tabStatus = DateType.yesterday;

        final DateTime yesterday =
            DateTime.now().subtract(const Duration(days: 1));

        final tasks = await getTaskList(yesterday);
        setState(() {
          selectedDate =
              DateTime(yesterday.year, yesterday.month, yesterday.day);
          yesterdayTaskList = tasks;
        });
        break;
      case 1:
        tabStatus = DateType.today;
        final DateTime today = DateTime.now();
        final tasks = await getTaskList(today);
        setState(() {
          selectedDate = DateTime(today.year, today.month, today.day);
          todayTaskList = tasks;
        });
        break;
      case 2:
        tabStatus = DateType.tomorrow;
        final DateTime tomorrow = DateTime.now().add(const Duration(days: 1));
        final tasks = await getTaskList(tomorrow);
        setState(() {
          selectedDate = DateTime(tomorrow.year, tomorrow.month, tomorrow.day);
          tomorrowTaskList = tasks;
        });
        tabStatus = DateType.tomorrow;
        break;
    }
  }

  Future<List<Task>> getTaskList(DateTime date) async {
    return await widget.isar.tasks
        .where()
        .filter()
        .runDateEqualTo(DateTime(date.year, date.month, date.day))
        .findAll();
  }

  Future<void> updateStatus(int id) async {
    await widget.isar.writeTxn(() async {
      final task = await widget.isar.tasks.get(id);

      if (task != null) {
        task.isCompleted = !task.isCompleted;
        await widget.isar.tasks.put(task);
      }
    });
    loadTasks();
  }

  Future<void> deleteTask(int id) async {
    await widget.isar.writeTxn(() async {
      await widget.isar.tasks.delete(id);
    });
    loadTasks();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const EmptyAppBar(),
      body: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              width: 146,
              alignment: Alignment.centerRight,
              child: Text(
                _getDate(selectedDate),
                style: TextStyle(
                  fontSize: 26,
                  color: tabStatus == DateType.yesterday
                      ? Colors.black54
                      : tabStatus == DateType.today
                          ? const Color(0xFF389764)
                          : Colors.yellow.shade800,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const Gap(8),
          TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: '昨日'),
              Tab(text: '今日'),
              Tab(text: '明日'),
            ],
            unselectedLabelColor: Colors.black,
            labelColor: Colors.black,
            indicator: const UnderlineTabIndicator(
              borderSide: BorderSide(
                width: 4.0,
                color: Colors.lightGreen,
              ),
            ),
            indicatorSize: TabBarIndicatorSize.label,
            labelStyle: const TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
            unselectedLabelStyle: const TextStyle(fontSize: 20.0),
          ),
          const Gap(8),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                TaskList(
                  tasks: yesterdayTaskList,
                  dateType: DateType.yesterday,
                  onUpdateStatus: updateStatus,
                  onDeleteTask: deleteTask,
                ),
                TaskList(
                  tasks: todayTaskList,
                  dateType: DateType.today,
                  onUpdateStatus: updateStatus,
                  onDeleteTask: deleteTask,
                ),
                TaskList(
                  tasks: tomorrowTaskList,
                  dateType: DateType.tomorrow,
                  onUpdateStatus: updateStatus,
                  onDeleteTask: deleteTask,
                ),
              ],
            ),
          ),
          const Gap(48),
        ],
      ),
      floatingActionButton: SizedBox(
        width: 90.0,
        height: 90.0,
        child: tabStatus == DateType.yesterday
            ? null
            : FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddTask(
                        isar: widget.isar,
                        dateType: tabStatus,
                      ),
                    ),
                  ).then((value) async {
                    await loadTasks();
                  });
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50.0),
                ),
                backgroundColor: tabStatus == DateType.today
                    ? const Color(0xFF389764)
                    : Colors.yellow.shade800,
                child: const Icon(
                  Icons.add_task,
                  size: 50,
                  color: Colors.white,
                ),
              ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: Colors.lightGreen,
        shape: const CircularNotchedRectangle(),
        notchMargin: 10,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(left: 36.0),
              child: IconButton(
                icon: const Icon(
                  Icons.directions_run,
                  color: Colors.white,
                  size: 40.0,
                ),
                onPressed: () {},
              ),
            ),
            Container(
              margin: const EdgeInsets.only(right: 36.0),
              child: IconButton(
                icon: const Icon(
                  Icons.history,
                  color: Colors.white,
                  size: 40.0,
                ),
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getDate(DateTime dateTime) {
    initializeDateFormatting('ja');
    final formatStrForDayOfWeek =
        DateFormat('MM/dd (E)', 'ja').format(dateTime);

    return formatStrForDayOfWeek;
  }
}
