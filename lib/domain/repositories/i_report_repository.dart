import '../models/report.dart';

abstract class IReportRepository {
  Future<List<Report>> getReports();
  Future<bool> addReport(Report report);
  Future<bool> updateReport(int reportId, int reviewScore);
  Future<List<Report>> getReportsBySupportUser(int supportUserId);
}
