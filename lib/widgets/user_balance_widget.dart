import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/user_controller.dart';

class UserBalanceWidget extends StatelessWidget {
  UserBalanceWidget({super.key});

  final UserController userController = Get.put(UserController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '用户余额: \$${userController.balance.toStringAsFixed(6)}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          ElevatedButton(
            onPressed: userController.fetchBalance,
            child: const Text('刷新'),
          ),
        ],
      ),
    );
  }
}
