import 'package:flutter/foundation.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:wegame/services/config_service.dart';
import 'package:wegame/services/user_balance_service.dart';
import 'package:wegame/utils/euum.dart';

class PocketBaseService {
  PocketBaseService._internal();

  static PocketBaseService? _instance;

  /// PocketBaseService单例工厂构造函数
  ///
  /// @return PocketBaseService实例
  factory PocketBaseService() {
    _instance ??= PocketBaseService._internal();
    return _instance!;
  }

  /// 初始化PocketBaseService实例
  ///
  /// @return void 无返回值
  PocketBaseService._internal();

  late final PocketBase _pb = PocketBase(Configure.PB_ENDPOINT);
  late final UserBalanceService userBalanceService = UserBalanceService(_pb);

  PocketBase get pb => _pb;

  /// 获取PocketBaseService实例并进行身份验证
  ///
  /// @return Future<PocketBaseService> 认证后的PocketBaseService实例
  static Future<PocketBaseService> getInstance() async {
    _instance ??= PocketBaseService._internal();
    await _instance!._authenticate();
    return _instance!;
  }

  /// 进行PocketBase身份验证
  ///
  /// @param retryCount 重试次数，默认为3
  /// @return Future<void> 无返回值
  Future<void> _authenticate({int retryCount = 3}) async {
    for (var i = 0; i < retryCount; i++) {
      try {
        await _pb.collection('_superusers').authWithPassword(
              'oliyo@qq.com',
              'gemini4094',
            );
        if (kDebugMode) {
          print('PocketBase authenticated successfully.');
        }
        return;
      } catch (e) {
        if (kDebugMode) {
          print('PocketBase authentication attempt ${i + 1} failed: $e');
        }
        if (i == retryCount - 1) {
          rethrow;
        }
        await Future.delayed(const Duration(seconds: 2));
      }
    }
  }

  /// 根据名称获取模型列表
  ///
  /// @param name 模型名称
  /// @param page 页码
  /// @param perPage 每页数量
  /// @return Future<List<RecordModel>> 模型记录列表
  Future<List<RecordModel>> getModelsByName(String name,
      {int? page, int? perPage}) async {
    try {
      final records = await pb.collection('fish_models').getList(
            filter: 'name~"$name"',
            page: page!,
            perPage: perPage ?? 15,
          );
      return records.items;
    } catch (e) {
      ConfigService.log('Error fetching models: $e');
      rethrow;
    }
  }

  /// 获取指定平台的API密钥
  ///
  /// @param platform 平台名称
  /// @return Future<String> API密钥
  Future<String> getApiKeys(String platform) async {
    try {
      final records = await pb.collection('keys').getList(
          filter: 'platform = "$platform"', perPage: 1, skipTotal: true);
      if (records.items.isNotEmpty) {
        return records.items.first.data['api_key'];
      }
      throw Exception('API key not found for platform: $platform');
    } catch (e) {
      ConfigService.log('Error fetching API key: $e');
      rethrow;
    }
  }
}
