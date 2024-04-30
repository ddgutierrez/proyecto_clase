import '../models/user_support.dart';

abstract class IUserRepository {
  Future<List<UserSupport>> getUsers();
  Future<bool> addUser(UserSupport user);
  Future<bool> updateUser(UserSupport user);
  Future<bool> deleteUser(int id);
  Future<bool> emailExists(String email);
  Future<UserSupport?> validateCredentials(String email, String password);
}
