import 'package:get/get.dart';
import 'package:wegame/services/pocketbase_service.dart';

class ModelController extends GetxController {
  final PocketBaseService _pocketBaseService = PocketBaseService();
  final models = <dynamic>[].obs;
  final pageSize = 15;
  var page = 1;
  var hasMore = true.obs;
  var searchQuery = '';

  /// 初始化控制器时获取模型列表
  ///
  /// @return void 无返回值
  @override
  void onInit() {
    super.onInit();
    fetchModels();
  }

  /// 获取模型列表
  ///
  /// @param name 可选参数，用于搜索模型名称
  /// @return Future<void> 无返回值
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

  /// 加载更多模型数据
  ///
  /// @return void 无返回值
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
