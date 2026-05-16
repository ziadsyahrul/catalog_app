import '../entities/product.dart';
import '../repositories/product_repository.dart';

class GetFavoriteProducts {
  final ProductRepository repository;

  GetFavoriteProducts(this.repository);

  Stream<List<Product>> call() {
    return repository.watchFavoriteProducts();
  }
}