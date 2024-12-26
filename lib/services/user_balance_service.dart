import 'package:flutter/foundation.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:wegame/services/dio_client.dart';
import 'package:dio/dio.dart';
import 'package:wegame/services/pocketbase_service.dart';
import 'package:wegame/utils/euum.dart';

class UserBalanceService {
  final PocketBase pb;
  final Dio _dio = DioClient().dio;

  UserBalanceService(this.pb);

  Future<double> fetchUserBalance() async {
    return await fetchRemoteUserBalance();
  }

  Future<double> fetchRemoteUserBalance() async {
    var apiKey = await PocketBaseService().getApiKeys(Configure.FISH_AUDIO);
    if (kDebugMode) {
      print(apiKey);
    }
    try {
      final response = await _dio.get(
        Configure.FISH_BALANCE_API_POINT,
        options: Options(headers: {'Authorization': 'Bearer $apiKey'}),
      );
      if (response.statusCode == 200) {
        if (kDebugMode) {
          print(
              'Remote balance fetched successfully: ${response.data['credit']}');
        }
        final credit = response.data['credit'];
        if (credit is double) {
          return credit;
        } else if (credit is String) {
          return double.tryParse(credit) ?? 0.0;
        } else {
          return 0.0;
        }
      } else {
        if (kDebugMode) {
          print('Failed to fetch remote balance');
        }
        throw Exception('Failed to fetch remote balance');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching remote balance: $e');
      }
      throw Exception('Failed to fetch remote balance');
    }
  }
}
