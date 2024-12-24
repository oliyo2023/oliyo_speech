import 'package:pocketbase/pocketbase.dart';
import 'package:wegame/services/user_balance_service.dart';

class PocketBaseService {
  PocketBaseService._internal();

  static PocketBaseService? _instance;

  factory PocketBaseService() {
    _instance ??= PocketBaseService._internal();
    return _instance!;
  }

  late final PocketBase _pb = PocketBase('https://8.140.206.248/pocketbase');
  late final UserBalanceService userBalanceService = UserBalanceService(_pb);

  PocketBase get pb => _pb;

  static Future<PocketBaseService> getInstance() async {
    _instance ??= PocketBaseService._internal();
    await _instance!._authenticate();
    return _instance!;
  }

  Future<void> _authenticate() async {
    try {
      await _pb.collection('_superusers').authWithPassword(
            'oliyo@qq.com',
            'gemini4094',
          );
      print('PocketBase authenticated successfully.');
    } catch (e) {
      print('PocketBase authentication failed: $e');
      // Handle authentication failure appropriately (e.g., show an error message)
    }
  }

  Future<List<RecordModel>> getModelsByName(String name,
      {int? page, int? perPage}) async {
    final records = await pb.collection('fish_models').getList(
          filter: 'name~"$name"',
          page: page!,
          perPage: perPage ?? 15,
        );
    return records.items;
  }
}
