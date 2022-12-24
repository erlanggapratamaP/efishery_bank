import 'package:efishery_bank/db/area_db.dart';
import 'package:efishery_bank/db/fish_db.dart';
import 'package:efishery_bank/db/size_db.dart';
import 'package:efishery_bank/model/area.dart';
import 'package:efishery_bank/model/size.dart';
import 'package:efishery_bank/provider/area_provider.dart';
import 'package:efishery_bank/provider/size_provider.dart';
import 'package:efishery_bank/view/widgets/activity_indicator.dart';
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
  void init() async {
    isLoading = true;
    fishes = [];
    await getListFish();
    await areaApiToDb();
    await sizeApiToDb();
    isLoading = false;
    notifyListeners();
  }

  Future<List<Fish>> addTwoListFromApiandDB(List<Fish> fishTemp) async {
    var fishGet = await FishProvider().getAPIListFish();
    List<Fish> newList = [];
    if (fishGet != null && fishTemp.isNotEmpty) {
      fishGet.removeWhere((element) => element.uuid == null);
      newList = <Fish>{...fishTemp, ...fishGet}.toList();
    } else if (fishGet != null) {
      newList = fishGet.toList();
    }
    return newList;
  }

  @override
  Future<List<Fish>> getListFish() async {
    isLoading = true;
    var fishesTemp = await _fishProvider.fishes();
    fishesTemp.sort(
        (a, b) => b.tglParsed.toString().compareTo(a.tglParsed.toString()));
    fishes = await addTwoListFromApiandDB(fishesTemp);

    isLoading = false;
    notifyListeners();

    return fishes;
  }

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
    var areaGet = await AreaProvider().getAPIListArea();
    if (areaGet != null) {
      for (var data in areaGet) {
        AreaLocal area = AreaLocal(province: data.province, city: data.city);
        _areaProvider.insertArea(area);
      }
    }
  }

  Future<void> sizeApiToDb() async {
    var sizeGet = await SizeProvider().getAPIListSize();
    if (sizeGet != null) {
      for (var data in sizeGet) {
        SizeFishLocal area = SizeFishLocal(size: data.size);
        _sizeProvider.insertSize(area);
      }
    }
  }
}
