import 'package:get/get.dart';
import '../../domain/use_case/report_usecase.dart';
import '../../domain/models/report.dart';
import 'package:loggy/loggy.dart';

class ReportController extends GetxController with UiLoggy {
  final RxList<Report> _reports = <Report>[].obs;
  final ReportUseCase reportUseCase = Get.find();
  final RxBool isLoading = false.obs; // Added isLoading observable

  List<Report> get reports => _reports;

  @override
  void onInit() {
    super.onInit();
    getReports();
  }

  Future<void> getReports() async {
    logInfo("Fetching reports");
    try {
      isLoading.value = true; // Set loading to true before fetching reports
      _reports.value = await reportUseCase.getReports();
    } catch (e) {
      logError('Failed to fetch reports', e);
    } finally {
      isLoading.value = false; // Set loading to false after fetching reports
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
        getReports();
      }
      return success;
    } catch (e) {
      logError('Failed to review report', e);
      return false;
    }
  }

   Future<void> getReportsBySupportUser(int supportUserId) async {
    logInfo("Fetching reports for support user: $supportUserId");
    try {
      isLoading.value = true;
      _reports.value = await reportUseCase.getReportsBySupportUser(supportUserId);
    } catch (e) {
      logError('Failed to fetch reports for support user', e);
    } finally {
      isLoading.value = false;
    }
  }
}
