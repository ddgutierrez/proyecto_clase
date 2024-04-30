import '../../../domain/models/user_support.dart';

abstract class IUserDataSource {
  Future<List<UserSupport>> getUsers();

  Future<bool> addUser(UserSupport user);

  Future<bool> updateUser(UserSupport user);

  Future<bool> deleteUser(int id);
  Future<UserSupport?> findUserByEmail(String email);
  
  Future<UserSupport?> validateCredentials(String email, String password);
}
