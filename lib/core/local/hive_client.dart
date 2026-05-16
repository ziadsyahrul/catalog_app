import 'package:hive_flutter/hive_flutter.dart';

class HiveClient {
  static const String productBoxName = 'products';
  static const String favoriteBoxName = 'favorites';


  static  Future<void> init() async {
    await Hive.initFlutter();
  }

  static Future<Box> openProductBox() async {
    return await Hive.openBox(productBoxName);
  }

  static Future<Box> openFavoriteBox() async {
    return await Hive.openBox(favoriteBoxName);
  }
}