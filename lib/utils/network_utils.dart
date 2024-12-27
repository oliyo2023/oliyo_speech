import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkUtils {
  static Future<bool> checkNetworkConnection() async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult != ConnectivityResult.none;
  }

  static void showNetworkError(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('网络连接不可用，请检查网络设置'),
        backgroundColor: Colors.red,
      ),
    );
  }
}
