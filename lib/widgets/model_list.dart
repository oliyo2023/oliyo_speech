import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';

class ModelList extends StatefulWidget {
  const ModelList({super.key});

  @override
  State<ModelList> createState() => _ModelListState();
}

class _ModelListState extends State<ModelList> {
  List<RecordModel> _audioModels = [];
  List<RecordModel> _filteredAudioModels = [];
  int _page = 1;
  final int _perPage = 15;
  bool _hasNextPage = true;
  bool _isLoadMoreRunning = false;
  late ScrollController _scrollController;
  final pb = PocketBase('https://8.140.206.248/pocketbase');
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchAudioModels();
    _scrollController = ScrollController()..addListener(_loadMore);
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_loadMore);
    _scrollController.dispose();
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchAudioModels({String? search}) async {
    if (_isLoadMoreRunning || !_hasNextPage) {
      return;
    }
    setState(() {
      _isLoadMoreRunning = true;
    });
    try {
      final res = await pb.collection('fish_models').getList(
            page: _page,
            perPage: _perPage,
            filter:
                search != null && search.isNotEmpty ? 'name ~ "$search"' : null,
          );
      final List<RecordModel> fetchedModels = res.items;
      if (fetchedModels.isNotEmpty) {
        setState(() {
          _audioModels.addAll(fetchedModels);
          _filterModels();
        });
      } else {
        setState(() {
          _hasNextPage = false;
        });
      }
    } catch (err) {
      print('Something went wrong!');
    }

    setState(() {
      _isLoadMoreRunning = false;
    });
  }

  void _loadMore() async {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        _hasNextPage &&
        !_isLoadMoreRunning) {
      setState(() {
        _page += 1;
      });
      _fetchAudioModels(search: _searchController.text);
    }
  }

  void _onSearchChanged() {
    _filterModels();
  }

  void _filterModels() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredAudioModels = _audioModels
          .where((model) =>
              model.data['name'].toString().toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 400,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const Text(
              '用户余额: \$100',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  labelText: '搜索名称',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(
              height: 300, // Adjust as needed
              child: ListView.separated(
                controller: _scrollController,
                itemCount: _filteredAudioModels.length + (_hasNextPage ? 1 : 0),
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 8.0),
                itemBuilder: (context, index) {
                  if (index < _filteredAudioModels.length) {
                    final model = _filteredAudioModels[index];
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
                              imageUrl: pb.files
                                  .getUrl(model, model.data['avstor'])
                                  .toString(),
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                            const SizedBox(width: 8.0),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    model.data['name'].toString(),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    model.data['description']
                                            ?.toString()
                                            .substring(
                                                0,
                                                model.data['description']
                                                            .toString()
                                                            .length >
                                                        20
                                                    ? 20
                                                    : model.data['description']
                                                        .toString()
                                                        .length) ??
                                        '',
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Row(
                                    children: [
                                      const Icon(Icons.task, size: 16),
                                      Text(model.data['task_count'].toString()),
                                      const SizedBox(width: 8.0),
                                      const Icon(Icons.thumb_up, size: 16),
                                      Text(model.data['like_count'].toString()),
                                      const SizedBox(width: 8.0),
                                      const Icon(Icons.share, size: 16),
                                      Text(model.data['shared_count']
                                          .toString()),
                                    ],
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      // TODO: Implement "Use Sound" functionality
                                    },
                                    child: const Text('Use Sound'),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  } else if (_hasNextPage) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
