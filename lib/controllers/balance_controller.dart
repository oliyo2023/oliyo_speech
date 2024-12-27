import 'package:get/get.dart';
import 'package:dio/dio.dart';
import '../utils/euum.dart';

class BalanceController extends GetxController {
  var balance = ''.obs;
  var isLoading = false.obs;

  Future<void> fetchBalance() async {
    isLoading.value = true;
    try {
      final dio = Dio();
      final response = await dio.get(
        Configure.DEEPSEEK_API_URL,
        options: Options(headers: {
          'Authorization': 'Bearer ${Configure.DEEPSEEK_API_KEY}',
        }),
      );

      if (response.statusCode == 200) {
        print('API Response: ${response.data}'); // 打印API响应
        final balanceInfos = response.data['balance_infos'] as List;
        if (balanceInfos.isNotEmpty) {
          final cnyBalance = balanceInfos.firstWhere(
            (info) => info['currency'] == 'CNY',
            orElse: () => balanceInfos.first,
          );
          balance.value = cnyBalance['total_balance']?.toString() ?? '未知';
        } else {
          balance.value = '未知';
        }
      }
    } catch (e) {
      print('Error fetching balance: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
