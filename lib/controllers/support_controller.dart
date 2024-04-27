import '../models/user_support.dart';
import '../services/api_service.dart';

class SupportController {
  static final SupportController _instance = SupportController._internal();
  factory SupportController() => _instance;
  SupportController._internal();

  ApiService apiService = ApiService();

  Future<void> addSupportUser(UserSupport user) async {
    if (await apiService.emailExists(user.email)) {
      throw Exception('Email already exists');
    } else {
      await apiService.addSupportUser(user);
    }
  }

  Future<bool> validateCredentials(String email, String password) async {
    try {
      List<UserSupport> users = await apiService.fetchSupportUsers();
      return users
          .any((user) => user.email == email && user.password == password);
    } catch (e) {
      print("Error validating credentials: $e");
      return false;
    }
  }

  Future<void> updateSupportUser(
      String id, Map<String, dynamic> userData) async {
    try {
      await apiService.updateSupportUser(id, userData);
    } catch (e) {
      throw Exception('Failed to update user: $e');
    }
  }

  Future<void> deleteSupportUser(String id) async {
    try {
      await apiService.deleteSupportUser(id);
    } catch (e) {
      throw Exception('Failed to delete user: $e');
    }
  }
}
