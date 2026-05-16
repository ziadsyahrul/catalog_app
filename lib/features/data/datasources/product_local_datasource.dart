import 'package:hive/hive.dart';

import '../../../core/error/exceptions.dart';
import '../models/product_model.dart';

abstract class ProductLocalDataSource {
  Future<void> cacheProducts(List<ProductModel> products);

  Future<List<ProductModel>> getCachedProducts();

  Future<void> toggleFavorite(int productId);

  Future<List<ProductModel>> getFavoriteProducts();

  Future<bool> isFavorite(int productId);

  Stream<List<ProductModel>> watchFavoriteProducts();
}

class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  final Box productBox;
  final Box favoriteBox;

  ProductLocalDataSourceImpl({
    required this.productBox,
    required this.favoriteBox,
  });

  @override
  Future<void> cacheProducts(List<ProductModel> products) async {
    try {
      final Map<String, dynamic> data = {
        for (var p in products) p.id.toString(): p.toJson(),
      };
      await productBox.putAll(data);
    } catch (e) {
      throw CacheException('Gagal menyimpan cache: $e');
    }
  }

  @override
  Future<List<ProductModel>> getCachedProducts() async {
    try {
      final data = productBox.values.toList();
      if (data.isEmpty) throw CacheException('Cache kosong');
      return data
          .map((e) => ProductModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    } catch (e) {
      throw CacheException('Gagal ambil cache: $e');
    }
  }

  // toggle favorite
  @override
  Future<void> toggleFavorite(int productId) async {
    try {
      final key = productId.toString();
      if (favoriteBox.containsKey(key)) {
        await favoriteBox.delete(key);
      } else {
        final product = productBox.get(key);
        if (product != null) {
          await favoriteBox.put(key, product);
        }
      }
    } catch (e) {
      throw CacheException('Gagal toggle favorite: $e');
    }
  }

  @override
  Future<List<ProductModel>> getFavoriteProducts() async {
    try {
      final data = favoriteBox.values.toList();
      return data
          .map((e) => ProductModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    } catch (e) {
      throw CacheException('Gagal ambil favorite: $e');
    }
  }

  @override
  Future<bool> isFavorite(int productId) async {
    return favoriteBox.containsKey(productId.toString());
  }

  @override
  Stream<List<ProductModel>> watchFavoriteProducts() async* {
    yield _getFavoritesFromBox();
    yield* favoriteBox.watch().map((_) => _getFavoritesFromBox());
  }

  List<ProductModel> _getFavoritesFromBox() {
    return favoriteBox.values
        .map((e) => ProductModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }
}
