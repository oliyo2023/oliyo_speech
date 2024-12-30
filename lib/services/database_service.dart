// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import 'dart:io';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();

  /// DatabaseService单例工厂构造函数
  ///
  /// @return DatabaseService实例
  factory DatabaseService() => _instance;

  /// 初始化DatabaseService实例
  ///
  /// @return void 无返回值
  DatabaseService._internal();

  Database? _database;

  /// 获取数据库实例，如果不存在则初始化
  ///
  /// @return Future<Database> 数据库实例
  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDatabase();
    return _database!;
  }

  /// 初始化数据库，配置数据库路径和版本
  ///
  /// @return Future<Database> 初始化后的数据库实例
  Future<Database> _initDatabase() async {
    if (Platform.isLinux || Platform.isMacOS || Platform.isWindows) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'app_database.db');
    return await openDatabase(
      path,
      version: 1,
    );
  }
}
