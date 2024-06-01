import 'package:hive/hive.dart';
part 'user_db.g.dart';

@HiveType(typeId: 2)
class UserSupportDb extends HiveObject {
  @HiveField(0)
  String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String email;
  @HiveField(3)
  final String password;

  UserSupportDb(
      {required this.id,
      required this.name,
      required this.email,
      required this.password});
}
