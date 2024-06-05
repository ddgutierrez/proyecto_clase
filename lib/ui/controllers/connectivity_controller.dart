import 'package:get/get.dart';
import 'package:loggy/loggy.dart';
import 'package:proyecto_clase/ui/controllers/report_controller.dart';
import '../../data/core/network_info.dart';

/// Code taken from https://github.com/augustosalazar/f_web_retool_hive/blob/main/lib/ui/controller/connectivity_controller.dart
class ConnectivityController extends GetxController with UiLoggy {
  final NetworkInfo network = Get.find();
  final _connection = false.obs;
  bool get connection => _connection.value;

  @override
  Future onInit() async {
    super.onInit();
    _connection.value = await network.isConnected();

    loggy.info("Internet?: $_connection");

    network.openStream();

    network.stream.listen((event) {
      _connection.value = event;
      loggy.info("Internet update?: $_connection");
    });
  }

  @override
  void onClose() {
    _connection.close();
  }
}
