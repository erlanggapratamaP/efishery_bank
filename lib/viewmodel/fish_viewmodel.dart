import 'package:efishery_bank/db/area_db.dart';
import 'package:efishery_bank/db/fish_db.dart';
import 'package:efishery_bank/db/size_db.dart';
import 'package:efishery_bank/helpers/check_connectivity.dart';
import 'package:efishery_bank/model/area.dart';
import 'package:efishery_bank/model/size.dart';
import 'package:efishery_bank/provider/area_provider.dart';
import 'package:efishery_bank/provider/size_provider.dart';
import 'package:flutter/material.dart';
import '../abstracts/fish_abstract.dart';
import '../model/fish.dart';
import '../provider/fish_provider.dart';

class FishViewModel extends ChangeNotifier implements FishAbstract {
  final FishDatabase _fishProvider = FishDatabase();
  final AreaDatabase _areaProvider = AreaDatabase();
  final SizeDatabase _sizeProvider = SizeDatabase();

  List<Fish> fishes = [];
  TextEditingController minPriceController = TextEditingController();
  TextEditingController maxPriceController = TextEditingController();
  double minPrice = 0.0;
  double maxPrice = 400000.0;
  late RangeValues currentRangeValues = RangeValues(minPrice, maxPrice);

  var isLoading = false;
  //inisialisasi data
  void init(context) async {
    isLoading = true;
    fishes = [];
    await ConnectionCheck(context).checkConnection();
    await initGetFish();
    await areaApiToDb();
    await sizeApiToDb();
    isLoading = false;
    notifyListeners();
  }

  // GET FUNCTION LIST
  @override
  Future<List<Fish>> getListFish() async {
    isLoading = true;
    var fishesTemp = await _fishProvider.fishes();
    fishesTemp.sort(
        (a, b) => b.timestamp.toString().compareTo(a.timestamp.toString()));
    fishes = fishesTemp;
    isLoading = false;
    notifyListeners();
    return fishes;
  }

  Future<List<Fish>> initGetFish() async {
    isLoading = true;
    fishes = await addTwoListFromApiandDB();
    fishes.sort(
        (a, b) => b.timestamp.toString().compareTo(a.timestamp.toString()));
    isLoading = false;
    notifyListeners();

    return fishes;
  }

  Future<List<Fish>> addTwoListFromApiandDB() async {
    var koneksi = await ConnectionCheck.getConnection();
    List<Fish> newList = [];
    if (koneksi == 'online') {
      var fishGet = await FishProvider().getAPIListFish();
      if (fishGet != null) {
        fishGet.removeWhere((element) => element.uuid == null);
        await addApiToDB(fishGet);
        newList = await _fishProvider.fishes();
      }
    } else {
      newList = await _fishProvider.fishes();
    }

    return newList;
  }

  Future<void> addApiToDB(List<Fish> fish) async {
    for (var data in fish) {
      await _fishProvider.insertFish(data);
    }
  }

  // FILTER FUNCTION
  Future<List<Fish>> filterPriceFish(context) async {
    isLoading = true;
    fishes = await getListFish();
    List<Fish> filteredFish = fishes.where((element) {
      return (int.parse(element.price ?? '0') > minPrice.toInt() &&
          int.parse(element.price ?? '0') < maxPrice.toInt());
    }).toList();
    fishes = filteredFish;
    isLoading = false;
    notifyListeners();
    return fishes;
  }

  // SORTING FUNCTION FROM PRICE
  Future<List<Fish>> sortPriceFish(context) async {
    isLoading = true;
    fishes = await getListFish();
    fishes.sort((a, b) {
      return a.price
          .toString()
          .toLowerCase()
          .compareTo(b.price.toString().toLowerCase());
    });
    isLoading = false;
    notifyListeners();
    return fishes;
  }

  // SEARCH FUNCTION
  Future<List<Fish>> searchPriceFish(String search, context) async {
    isLoading = true;
    fishes = await getListFish();
    List<Fish> searchFishes = fishes.where((element) {
      element.komoditas = element.komoditas ?? '';
      element.price = element.price ?? '0';
      element.size = element.size ?? '';
      element.areaProvinsi = element.areaProvinsi ?? '';
      element.areaKota = element.areaKota ?? '';
      return element.komoditas!.toLowerCase().contains(search) ||
          element.price!.toLowerCase().contains(search) ||
          element.size!.toLowerCase().contains(search) ||
          element.areaProvinsi!.toLowerCase().contains(search) ||
          element.areaKota!.toLowerCase().contains(search);
    }).toList();
    fishes = searchFishes;
    isLoading = false;
    notifyListeners();
    return fishes;
  }

  @override
  Future<void> addListFish(Fish fish, context) async {}

  //Get Area from API and Put in DB
  Future<void> areaApiToDb() async {
    var koneksi = await ConnectionCheck.getConnection();
    if (koneksi == 'online') {
      var areaGet = await AreaProvider().getAPIListArea();
      areaGet?.removeWhere((element) => element.province == null && element.city == null);
      var areaList = await _areaProvider.areas();
      if (areaGet != null) {
        if (areaList.isEmpty) {
          for (var data in areaGet) {
            AreaLocal area =
                AreaLocal(province: data.province, city: data.city);
            await _areaProvider.insertArea(area);
          }
        } 
      }
    }
  }

  Future<void> sizeApiToDb() async {
    var koneksi = await ConnectionCheck.getConnection();
    if (koneksi == 'online') {
      var sizeGet = await SizeProvider().getAPIListSize();
      var sizeListA = await _sizeProvider.sizes();
      if (sizeGet != null) {
        if (sizeListA.isEmpty) {
          for (var data in sizeGet) {
            SizeFishLocal area = SizeFishLocal(size: data.size);
            await _sizeProvider.insertSize(area);
          }
        } 
      }
    }
  }
}
