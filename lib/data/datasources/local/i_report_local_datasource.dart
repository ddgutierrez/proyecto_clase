import '../../../domain/models/report.dart';

abstract class IReportLocalDataSource {
  Future<List<Report>> getCachedReports();

  Future<void> addOfflineReport(Report report);

  Future<void> deleteReports();

  Future<void> deleteOfflineReport(Report report);

  Future<void> cacheReports(List<Report> reports);

  Future<List<Report>> getOfflineReports();

  Future<void> clearOfflineReports();

  Future<bool> updateReport(int reportId, int reviewScore);

  Future<List<Report>> getReportsBySupportUser(int supportUserId);
}
