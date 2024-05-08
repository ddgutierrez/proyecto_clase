import 'package:get/get.dart';
import '../../domain/use_case/report_usecase.dart';
import '../../domain/models/report.dart';
import 'package:loggy/loggy.dart';

class ReportController extends GetxController with UiLoggy {
  final RxList<Report> _reports = <Report>[].obs;
  final ReportUseCase reportUseCase = Get.find();

  List<Report> get reports => _reports;

  get isLoading => null;


  @override
  void onInit() {
    super.onInit();
    getReports();
  }

  Future<void> getReports() async {
    logInfo("Fetching reports");
    try {
      _reports.value = await reportUseCase.getReports();
    } catch (e) {
      logError('Failed to fetch reports', e);
    }
  }

  Future<bool> createReport(Report report) async {
    try {
      final success = await reportUseCase.addReport(report);
      if (success) {
        getReports();
      }
      return success;
    } catch (e) {
      logError('Failed to create report', e);
      return false;
    }
  }

  Future<bool> updateReport(int reportId, int reviewScore) async {
    try {
      final success = await reportUseCase.updateReport(reportId, reviewScore);
      if (success) {
        updateReport(reportId, reviewScore);
        getReports();
      }
      return success;
    } catch (e) {
      logError('Failed to review report', e);
      return false;
    }
  }

  Future<List<Report>> getReportsBySupportUser(int supportUserId) async {
    try {
      return await reportUseCase.getReportsBySupportUser(supportUserId);
    } catch (e) {
      logError('Failed to fetch reports for support user', e);
      return [];
    }
  }
}
