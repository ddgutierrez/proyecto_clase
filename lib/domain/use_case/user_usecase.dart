import 'package:loggy/loggy.dart';

import '../models/user_support.dart';
import '../repositories/i_user_repository.dart';

class UserUseCase {
  final IUserRepository _repository;

  UserUseCase(this._repository);

  Future<List<UserSupport>> getUsers() async => await _repository.getUsers();

  Future<bool> addUser(UserSupport user) async {
  try {
    return await _repository.addUser(user);
  } catch (e) {
    logError('Failed to add user', e);
    return false;
  }
}

  Future<bool> updateUser(UserSupport user) async => await _repository.updateUser(user);

  Future<bool> deleteUser(int id) async => await _repository.deleteUser(id);

  Future<bool> emailExists(String email) async => await _repository.emailExists(email);

  Future<UserSupport?> validateCredentials(String email, String password) async => await _repository.validateCredentials(email, password);
}
