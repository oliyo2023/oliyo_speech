import 'package:get/get.dart';
import '../services/user_balance_service.dart';
import '../services/pocketbase_service.dart';

class UserController extends GetxController {
  final _balanceService = UserBalanceService(PocketBaseService().pb);
  final _balance = 0.0.obs;

  double get balance => _balance.value;

  @override
  void onInit() {
    super.onInit();
    fetchBalance();
  }

  Future<void> fetchBalance() async {
    final balance = await _balanceService.fetchUserBalance();
    _balance.value = balance;
    Get.snackbar("余额更新提示", "用户余额已更新成功");
  }
}
