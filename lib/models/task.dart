import 'package:isar/isar.dart';

part 'task.g.dart';

@Collection()
class Task {
  Id id = Isar.autoIncrement;

  late String name;
  late String description;
  late DateTime runDate;

  late DateTime createAt;
}
