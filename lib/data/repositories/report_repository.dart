import 'package:loggy/loggy.dart';
import 'package:proyecto_clase/data/datasources/local/i_report_local_datasource.dart';

import '../../domain/models/report.dart';
import '../../domain/repositories/i_report_repository.dart';
import '../core/network_info.dart';
import '../datasources/remote/i_report_datasource.dart';

class ReportRepository implements IReportRepository {
  final IReportDataSource _reportDataSource;
  final IReportLocalDataSource _localDataSource;
  final NetworkInfo _networkInfo;

  ReportRepository(
      this._reportDataSource, this._localDataSource, this._networkInfo);

  @override
  Future<List<Report>> getReports() async {
    if (await _networkInfo.isConnected()) {
      logInfo("getReports online");
      List<Report> offlineReports = await _localDataSource.getOfflineReports();
      if (offlineReports.isNotEmpty) {
        logInfo("getReports found ${offlineReports.length} offline reports");
        for (var report in offlineReports) {
          logInfo(report.id);
          logInfo(report.supportUser);
          var rta = await _reportDataSource.addReport(report);
          if (rta) {
            await _localDataSource.deleteOfflineReport(report);
            await _localDataSource.popOfflineReport();
          } else {
            logError("getReports error adding offline report");
          }
        }
      }
      logInfo(offlineReports.length);
      final reports = await _reportDataSource.getReports();
      logInfo("getReports online reports: ${reports.length}");
      await _localDataSource.cacheReports(reports);
      return reports;
    }
    logInfo("getReports offline");
    return await _localDataSource.getCachedReports() +
        await _localDataSource.getOfflineReports();
  }

  @override
  Future<bool> addReport(Report report) async {
    if (await _networkInfo.isConnected()) {
      await _reportDataSource.addReport(report);
    } else {
      await _localDataSource.addOfflineReport(report);
    }
    return true;
  }

  @override
  Future<bool> updateReport(int reportId, int reviewScore) async {
    if (await _networkInfo.isConnected()) {
      await _reportDataSource.updateReport(reportId, reviewScore);
    } else {
      return false;
    }
    return true;
  }

  @override
  Future<List<Report>> getReportsBySupportUser(int supportUserId) async {
    if (await _networkInfo.isConnected()) {
      logInfo("getReportsByUser online");
      final offlineReports =
          await _localDataSource.getReportsBySupportUser(supportUserId);
      if (offlineReports.isNotEmpty) {
        logInfo(
            "getReportsByUser found ${offlineReports.length} offline reports");
        for (var report in offlineReports) {
          var rta = await _reportDataSource.addReport(report);
          if (rta) {
            await _localDataSource.deleteOfflineReport(report);
          } else {
            logError("getReportsByUser error adding offline report");
          }
        }
      }
      final reports =
          await _reportDataSource.getReportsBySupportUser(supportUserId);
      logInfo("getReportsByUser online reports: ${reports.length}");
      await _localDataSource.cacheReports(reports);
      return reports;
    }
    logInfo("getReportsByUser offline");
    final localOnly = await _localDataSource.getOfflineReports();
    return await _localDataSource.getCachedReports() +
        localOnly
            .where((report) => report.supportUser == supportUserId)
            .toList();
    //return _reportDataSource.getReportsBySupportUser(supportUserId);
  }
}
