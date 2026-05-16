import 'package:catalog_app/features/domain/entities/product.dart';
import 'package:catalog_app/features/domain/repositories/product_repository.dart';

class AddProduct {
  final ProductRepository repository;

  AddProduct(this.repository);

  Future<Product> call(Product product) async {
    return await repository.addProduct(product);
  }
}
