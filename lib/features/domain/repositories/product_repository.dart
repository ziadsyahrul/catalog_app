import 'package:catalog_app/features/domain/entities/product.dart';

abstract class ProductRepository {

  Future<List<Product>> getProducts();

  Future<Product> getProductById(int id);

  Future<Product> addProduct(Product product);

  Future<void> toggleFavorite(int id);

  Future<List<Product>> getFavoriteProducts();

  Future<bool> isFavorite(int productId);

  Stream<List<Product>> watchFavoriteProducts();
}