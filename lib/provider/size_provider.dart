import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../model/size.dart';

class SizeProvider {
  Future<List<SizeFish>?> getAPIListSize() async {
    try {
      var response = await Dio().get(
          'https://stein.efishery.com/v1/storages/5e1edf521073e315924ceab4/option_size');
      var dataResponse =
          List.from(response.data).map((e) => SizeFish.fromJson(e)).toList();
      return dataResponse;
    } catch (e) {
      debugPrint('$e');
      return null;
    }
  }
}
