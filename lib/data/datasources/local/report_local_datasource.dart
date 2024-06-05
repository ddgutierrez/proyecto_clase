import 'package:hive/hive.dart';
import 'package:loggy/loggy.dart';
import 'package:proyecto_clase/data/datasources/local/i_report_local_datasource.dart';
import 'package:proyecto_clase/domain/models/report.dart';

import '../../models/report_db.dart';

class ReportLocalDatasource implements IReportLocalDataSource {
  @override
  Future<void> addOfflineReport(Report report) async {
    logInfo("Adding OfflineReport");
    await Hive.box('reportsDbOffline').add(ReportDb(
        id: report.id,
        report: report.report,
        review: report.review,
        revised: report.revised,
        duration: report.duration,
        startTime: report.startTime,
        supportUser: report.supportUser,
        clientName: report.clientName));
    logInfo('addOfflineReport ${Hive.box('reportsDbOffline').values.length}');
  }

  @override
  Future<void> cacheReports(List<Report> reports) async {
    logInfo('pre-cacheReports ${Hive.box('reportsDb').values.length}');
    await Hive.box('reportsDb').clear();
    logInfo('pre-cacheReports ${Hive.box('reportsDb').values.length}');
    for (var report in reports) {
      await Hive.box('reportsDb').add(ReportDb(
          id: report.id,
          report: report.report,
          review: report.review,
          revised: report.revised,
          duration: report.duration,
          startTime: report.startTime,
          supportUser: report.supportUser,
          clientName: report.clientName));
    }
    logInfo('cacheReports ${Hive.box('reportsDb').values.length}');
  }

  @override
  Future<void> clearOfflineReports() async {
    await Hive.box('reportsDbOffline').clear();
  }

  @override
  Future<void> deleteOfflineReport(Report report) async {
    await Hive.box('reportsDbOffline').delete(report);
    logInfo("now offline has: ${Hive.box('reportsDbOffline').length}");
  }

  Future<void> popOfflineReport() async {
    logInfo("Removing one offline report");
    await Hive.box('reportsDbOffline').deleteAt(0);
    logInfo("Now offline has: ${Hive.box('reportsDbOffline').length}");
  }

  @override
  Future<void> deleteReports() async {
    await Hive.box('reportsDb').clear();
    await Hive.box('reportsDbOffline').clear();
  }

  @override
  Future<List<Report>> getCachedReports() async {
    logInfo('getCachedReports ${Hive.box('reportsDb').values.length}');
    return Hive.box('reportsDb')
        .values
        .map((entry) => Report(
            report: entry.report,
            id: entry.id,
            review: entry.review,
            revised: entry.revised,
            duration: entry.duration,
            startTime: entry.startTime,
            supportUser: entry.supportUser,
            clientName: entry.clientName))
        .toList();
  }

  @override
  Future<List<Report>> getOfflineReports() async {
    logInfo('getOfflineReports ${Hive.box('reportsDbOffline').values.length}');
    return Hive.box('reportsDbOffline')
        .values
        .map((entry) => Report(
            report: entry.report,
            id: entry.id,
            review: entry.review,
            revised: entry.revised,
            duration: entry.duration,
            startTime: entry.startTime,
            supportUser: entry.supportUser,
            clientName: entry.clientName))
        .toList();
  }

  @override
  Future<List<Report>> getReportsBySupportUser(int supportUserId) async {
    logInfo(
        'get ${Hive.box('reportsDbOffline').values.length} OfflineReports by user $supportUserId');
    return Hive.box('reportsDbOffline')
        .values
        .where((report) => report.supportUser == supportUserId)
        .map((entry) => Report(
            report: entry.report,
            id: entry.id,
            review: entry.review,
            revised: entry.revised,
            duration: entry.duration,
            startTime: entry.startTime,
            supportUser: entry.supportUser,
            clientName: entry.clientName))
        .toList();
  }

  @override
  Future<bool> updateReport(int reportId, int reviewScore) {
    // TODO: implement updateReport
    throw UnimplementedError();
  }
}
