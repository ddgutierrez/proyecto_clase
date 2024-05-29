import 'package:hive/hive.dart';

part 'client_db.g.dart';

//execute dart run build_runner build to generate the .g file

@HiveType(typeId: 1)
class ClientDb extends HiveObject {
  ClientDb({
    required this.name,
  });
  @HiveField(0)
  String name;
}
