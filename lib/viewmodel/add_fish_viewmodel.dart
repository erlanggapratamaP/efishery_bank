import 'package:efishery_bank/abstracts/fish_abstract.dart';
import 'package:efishery_bank/db/area_db.dart';
import 'package:efishery_bank/db/fish_db.dart';
import 'package:efishery_bank/db/size_db.dart';
import 'package:efishery_bank/model/area.dart';
import 'package:efishery_bank/model/fish.dart';
import 'package:efishery_bank/provider/area_provider.dart';
import 'package:efishery_bank/view/widgets/activity_indicator.dart';
import 'package:flutter/material.dart';

class AddFishViewModel extends ChangeNotifier implements FishAbstract {
  final FishDatabase _fishProvider = FishDatabase();
  final AreaDatabase _areaProvider = AreaDatabase();
  final SizeDatabase _sizeProvider = SizeDatabase();

  //Add fish
  List<String> sizeList = [];
  List<String> provinsiList = [];
  List<String> kotaList = [];
  String? valueSize;
  String? valueProvinsi;
  String? valueKota;
  TextEditingController komoditasController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  var isLoadingAdd = false;
  void initAdd() async {
    isLoadingAdd = true;
    valueSize = null;
    valueProvinsi = null;
    valueKota = null;
    komoditasController = TextEditingController();
    priceController = TextEditingController();
    sizeList = await getSize();
    provinsiList = await getProv();
    kotaList = [];
    isLoadingAdd = false;
    notifyListeners();
  }

  Future<List<String>> getProv() async {
    var areaList = await _areaProvider.areas();
    List<String> areaProvList = [];
    if (areaList.isNotEmpty) {
      for (var data in areaList) {
        if (data.province != null) {
          areaProvList.add(data.province!);
        }
      }
      var areaProvFinal = areaProvList.toSet().toList();
      notifyListeners();
      return areaProvFinal;
    } else {
      return areaProvList;
    }
  }

  Future<List<String>> getKotaByProv(String prov) async {
    var areaList = await _areaProvider.areas();
    List<AreaLocal>? areaKotaList = [];
    areaKotaList =
        areaList.where((element) => element.province == prov).toList();
    var clearArea = areaKotaList.toSet().toList();
    for (var data in clearArea) {
      kotaList.add(data.city ?? '');
    }
    notifyListeners();
    return kotaList;
  }

  Future<List<String>> getKota() async {
    var areaList = await AreaProvider().getAPIListArea();
    List<String> areaKotaList = [];
    if (areaList != null) {
      for (var data in areaList) {
        if (data.city != null) {
          areaKotaList.add(data.city!);
        }
      }
      var areaKotaFinal = areaKotaList.toSet().toList();
      notifyListeners();
      return areaKotaFinal;
    } else {
      return areaKotaList;
    }
  }

  Future<List<String>> getSize() async {
    var sizeListA = await _sizeProvider.sizes();
    List<String> sizeListTemp = [];
    if (sizeListA.isNotEmpty) {
      for (var data in sizeListA) {
        if (data.size != null) {
          sizeListTemp.add(data.size!);
        }
      }
      var sizeListFinal = sizeListTemp.toSet().toList();
      notifyListeners();
      return sizeListFinal;
    } else {
      return sizeListTemp;
    }
  }

  @override
  Future<void> addListFish(Fish fish, context) async {
    showActivityIndicator(context);
    await _fishProvider.insertFish(fish);
    notifyListeners();
    hideActivityIndicator(context);
  }

  @override
  Future<List<Fish>> getListFish() async {
    List<Fish> a = [];
    return a;
  }
}
