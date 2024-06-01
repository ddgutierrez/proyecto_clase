import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:loggy/loggy.dart';
import 'package:proyecto_clase/data/datasources/local/i_user_local_datasource.dart';
import 'package:proyecto_clase/domain/models/user_support.dart';

import '../../models/user_db.dart';

class UserLocalDatasource implements IUserLocalDataSource {
  @override
  Future<void> addOfflineUser(UserSupport user) async {
    logInfo("Adding addOfflineUser");
    await Hive.box('userDbOffline').add(UserSupportDb(
        id: user.id,
        name: user.name,
        email: user.email,
        password: user.password));
    logInfo('addOfflineUser ${Hive.box('userDbOffline').values.length}');
  }

  @override
  Future<void> cacheUsers(List<UserSupport> users) async {
    logInfo('pre-cacheUsers ${Hive.box('userDb').values.length}');
    await Hive.box('userDb').clear();
    logInfo('pre-cacheUsers ${Hive.box('userDb').values.length}');
    for (var user in users) {
      await Hive.box('userDb').add(UserSupportDb(
          id: user.id,
          name: user.name,
          email: user.email,
          password: user.password));
    }
    logInfo('cacheUsers ${Hive.box('userDb').values.length}');
  }

  @override
  Future<void> deleteOfflineUser(int id) async {
    await Hive.box('userDbOffline').delete(id);
  }

  @override
  Future<void> deleteUsers() async {
    await Hive.box('userDb').clear();
    await Hive.box('userDbOffline').clear();
  }

  @override
  Future<UserSupport?> findUserByEmail(String email) async {
    logInfo('Looking for user with $email');
    UserSupportDb? info = Hive.box('userDbOffline').get(email);
    return info != null
        ? UserSupport(
            id: info.id,
            name: info.name,
            email: info.email,
            password: info.password)
        : null;
  }

  @override
  Future<List<UserSupport>> getCachedUsers() async {
    logInfo('getCachedUsers ${Hive.box('userDb').values.length}');
    return Hive.box('userDb')
        .values
        .map((entry) => UserSupport(
            id: entry.id,
            name: entry.name,
            email: entry.email,
            password: entry.password))
        .toList();
  }

  @override
  Future<List<UserSupport>> getOfflineUsers() async {
    logInfo('getOfflineUsers ${Hive.box('userDbOffline').values.length}');
    return Hive.box('userDbOffline')
        .values
        .map((entry) => UserSupport(
            id: entry.id,
            name: entry.name,
            email: entry.email,
            password: entry.password))
        .toList();
  }

  @override
  Future<void> updateUser(UserSupport user) {
    // TODO: implement updateUser
    throw UnimplementedError();
  }

  @override
  Future<UserSupport?> validateCredentials(String email, String password) {
    // TODO: implement validateCredentials
    throw UnimplementedError();
  }
}
