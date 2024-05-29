import 'package:hive/hive.dart';
part 'user_db.g.dart';

@HiveType(typeId: 2)
class UserSupportDb extends HiveObject {
  @HiveField(0)
  final String name;
  @HiveField(1)
  final String email;
  @HiveField(2)
  final String password;

  UserSupportDb(
      {required this.name, required this.email, required this.password});
}
