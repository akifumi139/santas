import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import './empty_app_bar.dart';

enum DateType {
  yesterday,
  today,
  tomorrow,
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late DateTime selectedDate;
  late DateType tabStatus;

  @override
  void initState() {
    _tabController = TabController(
      length: 3,
      initialIndex: 1,
      vsync: this,
    );
    _tabController.addListener(() {
      updateSelectedDate();
    });
    selectedDate = DateTime.now();
    tabStatus = DateType.today;
    super.initState();
  }

  void updateSelectedDate() {
    switch (_tabController.index) {
      case 0:
        selectedDate = DateTime.now().subtract(const Duration(days: 1));
        tabStatus = DateType.yesterday;
        break;
      case 1:
        selectedDate = DateTime.now();
        tabStatus = DateType.today;

        break;
      case 2:
        selectedDate = DateTime.now().add(const Duration(days: 1));
        tabStatus = DateType.tomorrow;
        break;
    }
    setState(() {});
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
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                Center(child: Text("Yesterday's in task")),
                Center(child: Text("Today's Tasks")),
                Center(child: Text("Tomorrow's Tasks")),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: SizedBox(
        width: 90.0,
        height: 90.0,
        child: tabStatus == DateType.yesterday
            ? null
            : FloatingActionButton(
                onPressed: () {},
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
        notchMargin: 14,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(left: 40.0),
              child: IconButton(
                icon: const Icon(
                  Icons.directions_run,
                  color: Colors.white,
                  size: 46.0,
                ),
                onPressed: () {},
              ),
            ),
            Container(
              margin: const EdgeInsets.only(right: 40.0),
              child: IconButton(
                icon: const Icon(
                  Icons.history,
                  color: Colors.white,
                  size: 46.0,
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
