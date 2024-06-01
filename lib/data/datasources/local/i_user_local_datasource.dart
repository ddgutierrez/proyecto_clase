import '../../../domain/models/user_support.dart';

abstract class IUserLocalDataSource {
  Future<void> addOfflineUser(UserSupport user);

  Future<List<UserSupport>> getCachedUsers();

  Future<void> deleteUsers();

  Future<void> deleteOfflineUser(int id);

  Future<void> cacheUsers(List<UserSupport> users);

  Future<List<UserSupport>> getOfflineUsers();

  Future<void> updateUser(UserSupport user);

  Future<UserSupport?> findUserByEmail(String email);

  Future<UserSupport?> validateCredentials(String email, String password);
}
