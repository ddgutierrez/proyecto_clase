import '../../domain/models/user_support.dart';

class CoordinatorController {
  final List<UserSupport> _coordinators = [
    UserSupport(
        id: 'UC1',
        name: 'Coordinator A',
        email: 'a@a.com',
        password: 'passwordA'),
    UserSupport(
        id: 'UC2',
        name: 'Coordinator B',
        email: 'b@a.com',
        password: 'passwordB'),
  ];

  bool validateCredentials(String email, String password) {
    return _coordinators
        .any((user) => user.email == email && user.password == password);
  }
}
