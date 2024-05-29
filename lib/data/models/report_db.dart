import 'package:hive/hive.dart';

part 'report_db.g.dart';

//execute dart run build_runner build to generate the .g file

@HiveType(typeId: 3)
class ReportDb extends HiveObject {
  ReportDb({
    required this.report,
    required this.review,
    required this.revised,
    required this.duration,
    required this.startTime,
    required this.supportUser,
    required this.clientName,
  });
  @HiveField(0)
  String report;
  @HiveField(1)
  int review;
  @HiveField(2)
  bool revised;
  @HiveField(3)
  int duration;
  @HiveField(4)
  String startTime;
  @HiveField(5)
  int supportUser;
  @HiveField(6)
  String clientName;
}
