import 'package:pocketbase/pocketbase.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserBalanceService {
  final PocketBase pb;

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
      final response = await http.get(
        Uri.parse('https://api.fish.audio/wallet/self/api-credit'),
        headers: {'Authorization': 'Bearer $apiKey'},
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('Remote balance fetched successfully: ${data['credit']}');
        return double.parse(data['credit']);
      } else {
        print('Failed to fetch remote balance');
        throw Exception('Failed to fetch remote balance');
      }
    } else {
      print('No API key found');
      throw Exception('No API key found');
    }
  }
}
