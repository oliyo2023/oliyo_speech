import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';
import '../services/pocketbase_service.dart';

class ModelList extends StatefulWidget {
  const ModelList({super.key});

  @override
  State<ModelList> createState() => _ModelListState();
}

class _ModelListState extends State<ModelList> {
  List<RecordModel> _audioModels = [];
  int _page = 1;
  final int _perPage = 15;
  bool _hasNextPage = true;
  bool _isLoadMoreRunning = false;
  double _userBalance = 0.0; // Add this line
  late ScrollController _scrollController;
  final PocketBaseService _pocketBaseService = PocketBaseService();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchUserBalance(); // Add this line
    _fetchAudioModels();
    _scrollController = ScrollController()..addListener(_loadMore);
    _searchController.addListener(_onSearchChanged);
  }

  Future<void> _fetchUserBalance() async {
    final balance = await _pocketBaseService.fetchUserBalance();
    if (mounted) {
      setState(() {
        _userBalance = balance;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_loadMore);
    _scrollController.dispose();
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchAudioModels() async {
    if (_isLoadMoreRunning) {
      return;
    }

    setState(() {
      _isLoadMoreRunning = true;
    });

    try {
      List<RecordModel> fetchedModels;
      if (_searchController.text.isNotEmpty) {
        final res =
            await _pocketBaseService.pb.collection('fish_models').getList(
                  filter: 'name ~ "${_searchController.text}"',
                  page: _page,
                  perPage: _perPage,
                );
        fetchedModels = res.items;
        if (mounted) {
          setState(() {
            _hasNextPage = res.totalItems > (_page * _perPage);
          });
        }
      } else {
        final res =
            await _pocketBaseService.pb.collection('fish_models').getList(
                  page: _page,
                  perPage: _perPage,
                );
        fetchedModels = res.items;
        if (mounted) {
          setState(() {
            _hasNextPage = res.totalItems > (_page * _perPage);
          });
        }
      }

      if (mounted) {
        setState(() {
          if (_searchController.text.isEmpty) {
            _audioModels.addAll(fetchedModels);
          } else {
            _audioModels = fetchedModels;
          }
        });
      }
    } catch (err) {
      print('Something went wrong!');
    }

    if (mounted) {
      setState(() {
        _isLoadMoreRunning = false;
      });
    }

    if (mounted) {
      setState(() {
        _isLoadMoreRunning = false;
      });
    }
  }

  void _loadMore() async {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        _hasNextPage &&
        !_isLoadMoreRunning) {
      setState(() {
        _page += 1;
      });
      _fetchAudioModels();
    }
  }

  void _onSearchChanged() {
    setState(() {
      _audioModels.clear();
      _page = 1;
      _hasNextPage = true;
    });
    _fetchAudioModels();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 400,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              '用户余额: \$${_userBalance.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
            Expanded(
              child: SizedBox(
                child: ListView.separated(
                    controller: _scrollController,
                    itemCount: _audioModels.length + (_hasNextPage ? 1 : 0),
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 8.0),
                    itemBuilder: (context, index) {
                      if (index < _audioModels.length) {
                        final model = _audioModels[index];
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
                                  imageUrl: _pocketBaseService.pb.files
                                      .getUrl(model, model.data['avstor'])
                                      .toString(),
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                                const SizedBox(width: 8.0),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
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
                                                        : model
                                                            .data['description']
                                                            .toString()
                                                            .length) ??
                                            '',
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Row(
                                        children: [
                                          const Icon(Icons.task, size: 16),
                                          Text(model.data['task_count']
                                              .toString()),
                                          const SizedBox(width: 30.0),
                                          const Icon(Icons.thumb_up, size: 16),
                                          Text(model.data['like_count']
                                              .toString()),
                                          const SizedBox(width: 30.0),
                                          const Icon(Icons.share, size: 16),
                                          Text(model.data['shared_count']
                                              .toString()),
                                        ],
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          // TODO: Implement "Use Sound" functionality
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
                      } else if (_hasNextPage) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
