import 'package:efishery_bank/model/fish.dart';

abstract class FishAbstract {
  Future<void> addListFish(Fish fish, context);
  Future<List<Fish>> getListFish();
}
