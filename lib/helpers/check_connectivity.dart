import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConnectionCheck {
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  final Connectivity _connectivity = Connectivity();
  final BuildContext context;
  late SharedPreferences prefs;
  ConnectionCheck(this.context);
  checkConnection() async {
    late ConnectivityResult result;
    try {
      _connectivitySubscription =
          _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    } catch (e) {
      return;
    }
  }

  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } catch (e) {
      return;
    }
    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    prefs = await SharedPreferences.getInstance();
    var hasil = result.toString();
    switch (hasil) {
      case "ConnectivityResult.wifi":
        {
          await prefs.setString("koneksi", "online");
        }
        break;
      case "ConnectivityResult.mobile":
        {
          await prefs.setString("koneksi", "online");
        }

        break;
      default:
        {
          await prefs.setString("koneksi", "offline");
        }
        break;
    }
  }

  static Future<String> getConnection() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("koneksi") ?? "";
  }
}
