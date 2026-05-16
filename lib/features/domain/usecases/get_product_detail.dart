import 'package:catalog_app/features/domain/entities/product.dart';
import 'package:catalog_app/features/domain/repositories/product_repository.dart';

class GetProductDetail {

  final ProductRepository repository;

  GetProductDetail(this.repository);

  Future<Product> call(int id) async {
    return await repository.getProductById(id);
  }
}