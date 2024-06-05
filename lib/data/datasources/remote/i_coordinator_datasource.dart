import '../../../domain/models/coordinator.dart';

abstract class ICoordinatorDataSource {
  Future<Coordinator?> validateCredentials(String email, String password);
}
