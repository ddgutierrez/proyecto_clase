import '../models/user_support.dart';

class SupportController {
  static final SupportController _instance = SupportController._internal();
  factory SupportController() => _instance;
  SupportController._internal();

  List<UserSupport> _supportStaff = [];

  void addSupportUser(UserSupport user) {
    _supportStaff.add(user);
    print("New user created: ${user.name}, Email: ${user.email}");
  }

  bool validateCredentials(String email, String password) {
    return _supportStaff.any((user) => user.email == email && user.password == password);
  }
}
