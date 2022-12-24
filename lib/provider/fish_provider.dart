import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../model/fish.dart';

class FishProvider {
  Future<List<Fish>?> getAPIListFish() async {
    try {
      var response = await Dio().get(
          'https://stein.efishery.com/v1/storages/5e1edf521073e315924ceab4/list?limit=0&offset=0');
      var dataResponse =
          List.from(response.data).map((e) => Fish.fromJson(e)).toList();
      return dataResponse;
    } catch (e) {
      debugPrint('$e');
      return null;
    }
  }
}
