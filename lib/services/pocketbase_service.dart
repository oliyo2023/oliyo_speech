import 'package:pocketbase/pocketbase.dart';

class PocketBaseService {
  static final PocketBaseService _instance = PocketBaseService._internal();
  final PocketBase pb = PocketBase('https://8.140.206.248/pocketbase');

  factory PocketBaseService() {
    return _instance;
  }

  PocketBaseService._internal();

  Future<List<RecordModel>> getModelsByName(String name) async {
    final records = await pb.collection('models').getFullList(
          filter: 'name ~ "$name"',
        );
    return records;
  }

  Future<double> fetchUserBalance() async {
    final records = await pb.collection('keys').getList(
          filter: 'platform = "fishaudio"',
          perPage: 1,
        );
    if (records.items.isNotEmpty) {
      return records.items.first.data['balance'] as double;
    }
    return 0.0; // Or handle the case where no record is found
  }
}
