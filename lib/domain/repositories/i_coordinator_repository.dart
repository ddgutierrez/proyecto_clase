import '../models/coordinator.dart';

abstract class ICoordinatorRepository {
  Future<Coordinator?> validateCredentials(String email, String password);
}
