import 'package:pocketbase/pocketbase.dart';
import 'package:wegame/services/dio_client.dart';
import 'package:dio/dio.dart';

class UserBalanceService {
  final PocketBase pb;
  final Dio _dio = DioClient().dio;

  UserBalanceService(this.pb);

  Future<double> fetchUserBalance() async {
    return await fetchRemoteUserBalance();
  }

  Future<double> fetchRemoteUserBalance() async {
    final records = await pb
        .collection('keys')
        .getList(filter: 'platform = "fishaudio"', perPage: 1, skipTotal: true);
    if (records.items.isNotEmpty) {
      final apiKeyRecord = records.items.first;
      final apiKey = apiKeyRecord.data['api_key'];
      print('Fetching remote user balance...');
      try {
        final response = await _dio.get(
          'https://api.fish.audio/wallet/self/api-credit',
          options: Options(headers: {'Authorization': 'Bearer $apiKey'}),
        );
        if (response.statusCode == 200) {
          print(
              'Remote balance fetched successfully: ${response.data['credit']}');
          final credit = response.data['credit'];
          if (credit is double) {
            return credit;
          } else if (credit is String) {
            return double.tryParse(credit) ?? 0.0;
          } else {
            return 0.0;
          }
        } else {
          print('Failed to fetch remote balance');
          throw Exception('Failed to fetch remote balance');
        }
      } catch (e) {
        print('Error fetching remote balance: $e');
        throw Exception('Failed to fetch remote balance');
      }
    } else {
      print('No API key found');
      throw Exception('No API key found');
    }
  }
}
