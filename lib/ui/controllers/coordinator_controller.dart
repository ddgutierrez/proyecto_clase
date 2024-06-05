import 'package:get/get.dart';
import '../../domain/use_case/coordinator_usecase.dart';
import 'package:loggy/loggy.dart';

class CoordinatorController extends GetxController with UiLoggy {
  final CoordinatorUseCase coordinatorUseCase = Get.find();

  Future<bool> validateCredentials(String email, String password) async {
    try {
      final user = await coordinatorUseCase.validateCredentials(email, password);
      return user != null;
    } catch (e) {
      logError('Failed to validate credentials', e);
      return false;
    }
  }
}
