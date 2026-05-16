import 'package:catalog_app/features/data/datasources/product_local_datasource.dart';
import 'package:catalog_app/features/data/datasources/product_remote_datasource.dart';
import 'package:catalog_app/features/domain/entities/product.dart';
import 'package:catalog_app/features/domain/repositories/product_repository.dart';

import '../../../core/error/exceptions.dart';
import '../../../core/error/failures.dart';
import '../models/product_model.dart';

class ProductRepositoryImpl implements ProductRepository{

  final ProductRemoteDatasource remoteDataSource;
  final ProductLocalDataSource localDataSource;

  ProductRepositoryImpl({
      required this.remoteDataSource,
      required this.localDataSource});

  @override
  Future<List<Product>> getProducts() async {
    try {
      final remoteProducts = await remoteDataSource.getProducts();

      await localDataSource.cacheProducts(remoteProducts);

      return remoteProducts.map((model) => model.toEntity()).toList();
    } on ServerException {
      try {
        final localProducts = await localDataSource.getCachedProducts();
        return localProducts.map((model) => model.toEntity()).toList();
      } on CacheException catch (e) {
        throw CacheFailure(e.message);
      }
    }
  }

  @override
  Future<Product> getProductById(int id) async {
    try {
      final product = await remoteDataSource.getProductById(id);

      // cek apakah produk ini ada di favoriteBox
      final isFavorite = await localDataSource.isFavorite(id);

      // kembalikan entity dengan isFavorite yang benar
      return product.toEntity().copyWith(isFavorite: isFavorite);
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    }
  }

  @override
  Future<Product> addProduct(Product product) async {
    try {
      final productModel = ProductModel.fromEntity(product);
      final result = await remoteDataSource.addProduct(productModel);
      return result.toEntity();
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    }
  }

  @override
  Future<void> toggleFavorite(int productId) async {
    try {
      await localDataSource.toggleFavorite(productId);
    } on CacheException catch (e) {
      throw CacheFailure(e.message);
    }
  }

  @override
  Future<List<Product>> getFavoriteProducts() async {
    try {
      final favorites = await localDataSource.getFavoriteProducts();
      return favorites.map((model) => model.toEntity()).toList();
    } on CacheException catch (e) {
      throw CacheFailure(e.message);
    }
  }

  @override
  Future<bool> isFavorite(int productId) async {
    try {
      return await localDataSource.isFavorite(productId);
    } on CacheException catch (e) {
      throw CacheFailure(e.message);
    }
  }

  @override
  Stream<List<Product>> watchFavoriteProducts() {
    return localDataSource
        .watchFavoriteProducts()
        .map((models) => models.map((m) => m.toEntity()).toList());
  }

}