import 'package:get/get.dart';
import '../../domain/use_case/user_usecase.dart';
import '../../domain/models/user_support.dart';
import 'package:loggy/loggy.dart';

class SupportController extends GetxController with UiLoggy {
  final RxList<UserSupport> _users = <UserSupport>[].obs;
  final UserUseCase userUseCase = Get.find();

  List<UserSupport> get users => _users;

  @override
  void onInit() {
    super.onInit();
    getUsers();
  }

  Future<void> getUsers() async {
    logInfo("Getting clients");
    _users.value = await userUseCase.getUsers();
  }

  Future<bool> addUser(UserSupport user) async {
    try {
      final success = await userUseCase.addUser(user);
      if (success) {
        getUsers();
      }
      return success;
    } catch (e) {
      logError('Failed to add user', e);
      return false;
    }
  }

  Future<bool> updateUser(UserSupport user) async {
    try {
      final success = await userUseCase.updateUser(user);
      if (success) {
        getUsers(); 
      }
      return success;
    } catch (e) {
      logError('Failed to update user', e);
      return false;
    }
  }

  Future<bool> deleteUser(int id) async {
    try {
      final success = await userUseCase.deleteUser(id);
      if (success) {
        getUsers(); // Refresh the list after deletion
      }
      return success;
    } catch (e) {
      logError('Failed to delete user', e);
      return false;
    }
  }

  Future<bool> emailExists(String email) async {
    try {
      return await userUseCase.emailExists(email);
    } catch (e) {
      logError('Failed to check email existence', e);
      return false;
    }
  }

  Future<String?> validateCredentials(String email, String password) async {
    try {
      final user = await userUseCase.validateCredentials(email, password);
      return user?.id;
    } catch (e) {
      logError('Failed to validate credentials', e);
      return null;
    }
  }
}