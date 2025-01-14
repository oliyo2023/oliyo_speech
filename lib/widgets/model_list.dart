import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_network_image_platform_interface/cached_network_image_platform_interface.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/model_controller.dart';
import '../services/pocketbase_service.dart';
import 'user_balance_widget.dart';

class ModelList extends StatefulWidget {
  const ModelList({super.key, required this.onModelSelected});

  final Function(dynamic) onModelSelected;

  @override
  State<ModelList> createState() => _ModelListState();
}

class _ModelListState extends State<ModelList> {
  final ModelController controller = Get.find();
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _apiKeyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _apiKeyController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      controller.loadMoreModels();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 400,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            UserBalanceWidget(),
            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Search by Name',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      controller.fetchModels(name: controller.searchQuery);
                    },
                  ),
                  border: const OutlineInputBorder(),
                ),
                controller: TextEditingController(text: controller.searchQuery),
                onChanged: (value) {
                  controller.searchQuery = value;
                },
              ),
            ),
            Expanded(
              child: Obx(
                () => ListView.separated(
                  controller: _scrollController,
                  itemCount: controller.models.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 8.0),
                  itemBuilder: (context, index) {
                    final model = controller.models[index];
                    return Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade600),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CachedNetworkImage(
                              imageUrl: PocketBaseService()
                                  .pb
                                  .files
                                  .getUrl(model, model.data['avstor'])
                                  .toString(),
                              imageRenderMethodForWeb:
                                  ImageRenderMethodForWeb.HttpGet,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                            const SizedBox(width: 8.0),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    model.data['name'].toString(),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    model.data['description']?.toString() ?? '',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                  if ((model.data['description']
                                              ?.toString()
                                              .length ??
                                          0) >
                                      20)
                                    Text(
                                      '...',
                                    ),
                                  Row(
                                    children: [
                                      const Icon(Icons.task, size: 16),
                                      Expanded(
                                          child: Text(model.data['task_count']
                                              .toString())),
                                      const SizedBox(width: 16.0),
                                      const Icon(Icons.thumb_up, size: 16),
                                      Expanded(
                                          child: Text(model.data['like_count']
                                              .toString())),
                                      const SizedBox(width: 16.0),
                                      const Icon(Icons.share, size: 16),
                                      Expanded(
                                          child: Text(model.data['shared_count']
                                              .toString())),
                                    ],
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      setState(() {});
                                      widget.onModelSelected(model);
                                    },
                                    child: const Text('使用声音'),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
