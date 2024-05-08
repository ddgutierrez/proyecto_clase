import '../../../domain/models/report.dart';

abstract class IReportDataSource {
  Future<List<Report>> getReports();

  Future<bool> addReport(Report report);

  Future<bool> updateReport(int reportId, int reviewScore);

  Future<List<Report>> getReportsBySupportUser(int supportUserId);
}
