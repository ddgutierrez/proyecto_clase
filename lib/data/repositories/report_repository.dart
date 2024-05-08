import '../../domain/models/report.dart';
import '../../domain/repositories/i_report_repository.dart';
import '../datasources/remote/i_report_datasource.dart';

class ReportRepository implements IReportRepository {
  final IReportDataSource _reportDataSource;

  ReportRepository(this._reportDataSource);

  @override
  Future<List<Report>> getReports() {
    return _reportDataSource.getReports();
  }

  @override
  Future<bool> addReport(Report report) {
    return _reportDataSource.addReport(report);
  }

  @override
  Future<bool> updateReport(int reportId, int reviewScore) {
    return _reportDataSource.updateReport(reportId, reviewScore);
  }
  
  @override
  Future<List<Report>> getReportsBySupportUser(int supportUserId) {
    return _reportDataSource.getReportsBySupportUser(supportUserId);
  }
}