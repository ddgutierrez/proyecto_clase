import 'package:hive/hive.dart';

part 'report_db.g.dart';

//execute dart run build_runner build to generate the .g file

@HiveType(typeId: 3)
class ReportDb extends HiveObject {
  ReportDb({
    this.id,
    required this.report,
    required this.review,
    required this.revised,
    required this.duration,
    required this.startTime,
    required this.supportUser,
    required this.clientName,
  });
  @HiveField(0)
  int? id;
  @HiveField(1)
  String report;
  @HiveField(2)
  int review;
  @HiveField(3)
  bool revised;
  @HiveField(4)
  int duration;
  @HiveField(5)
  String startTime;
  @HiveField(6)
  int supportUser;
  @HiveField(7)
  String clientName;
}
