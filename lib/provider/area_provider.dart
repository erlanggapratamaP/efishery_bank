import 'package:dio/dio.dart';
import 'package:efishery_bank/model/area.dart';
import 'package:flutter/material.dart';


class AreaProvider {
  Future<List<Area>?> getAPIListArea() async {
    try {
      var response = await Dio().get(
          'https://stein.efishery.com/v1/storages/5e1edf521073e315924ceab4/option_area');
      var dataResponse =
          List.from(response.data).map((e) => Area.fromJson(e)).toList();
      return dataResponse;
    } catch (e) {
      debugPrint('$e');
      return null;
    }
  }
}
