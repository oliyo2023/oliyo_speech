import 'package:get/get.dart';
import 'package:wegame/services/pocketbase_service.dart';

class ModelController extends GetxController {
  final PocketBaseService _pocketBaseService = PocketBaseService();
  final models = <dynamic>[].obs;
  final pageSize = 15;
  var page = 1;
  var hasMore = true.obs;
  var searchQuery = '';

  @override
  void onInit() {
    super.onInit();
    fetchModels();
  }

  Future<void> fetchModels({String? name}) async {
    searchQuery = name ?? '';
    page = 1;
    hasMore.value = true;
    models.clear();
    final fetchedModels = await _pocketBaseService.getModelsByName(
      searchQuery,
      page: page,
      perPage: pageSize,
    );
    if (fetchedModels.length < pageSize) {
      hasMore.value = false;
    }
    models.value = fetchedModels;
  }

  void loadMoreModels() async {
    if (hasMore.value) {
      page++;
      final fetchedModels = await _pocketBaseService.getModelsByName(
        searchQuery,
        page: page,
        perPage: pageSize,
      );
      if (fetchedModels.isEmpty) {
        hasMore.value = false;
      } else {
        models.addAll(fetchedModels);
      }
    }
  }
}
