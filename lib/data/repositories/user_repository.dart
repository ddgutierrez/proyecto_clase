import '../../domain/models/user_support.dart';
import '../../domain/repositories/i_user_repository.dart';
import '../datasources/remote/i_user_datasource.dart';

class UserRepository implements IUserRepository {
  final IUserDataSource _userDataSource;

  UserRepository(this._userDataSource);

  @override
  Future<List<UserSupport>> getUsers() {
    return _userDataSource.getUsers();
  }

  @override
  Future<bool> addUser(UserSupport user) {
    return _userDataSource.addUser(user);
  }

  @override
  Future<bool> updateUser(UserSupport user) {
    return _userDataSource.updateUser(user);
  }

  @override
  Future<bool> deleteUser(int id) {
    return _userDataSource.deleteUser(id);
  }
  
  @override
  Future<bool> emailExists(String email) async {
    final user = await _userDataSource.findUserByEmail(email);
    return user != null;
  }

  @override
  Future<UserSupport?> validateCredentials(String email, String password) async {
    return await _userDataSource.validateCredentials(email, password);
  }
}