import 'package:flutter/foundation.dart';
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
    try {
      final balance = await _balanceService.fetchUserBalance();
      if (kDebugMode) {
        print('Fetched balance: $balance');
      }
      _balance.value = balance;
      if (kDebugMode) {
        print('Updated _balance.value: ${_balance.value}');
      }
      Get.snackbar("余额更新提示", "用户余额已更新成功");
    } catch (e) {
      Get.snackbar("余额更新提示", "用户余额获取失败");
    }
  }
}
