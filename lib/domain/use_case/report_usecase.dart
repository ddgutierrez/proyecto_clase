import 'package:loggy/loggy.dart';

import '../models/report.dart';
import '../repositories/i_report_repository.dart';

class ReportUseCase {
  final IReportRepository _repository;

  ReportUseCase(this._repository);

  Future<List<Report>> getReports() async => await _repository.getReports();

  Future<bool> addReport(Report report) async {
  try {
    return await _repository.addReport(report);
  } catch (e) {
    logError('Failed to add report', e);
    return false;
  }
}

  Future<bool> updateReport(int reportId, int reviewScore) async => await _repository.updateReport(reportId,reviewScore);

  Future<List<Report>> getReportsBySupportUser(int supportUserId) async => await _repository.getReportsBySupportUser(supportUserId);
}
