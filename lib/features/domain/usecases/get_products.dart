import 'package:catalog_app/features/domain/entities/product.dart';
import 'package:catalog_app/features/domain/repositories/product_repository.dart';

class GetProducts {
  final ProductRepository repository;

  GetProducts(this.repository);

  Future<List<Product>> call() async {
    return await repository.getProducts();
  }
}