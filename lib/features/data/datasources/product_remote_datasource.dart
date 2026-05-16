import 'package:catalog_app/core/error/exceptions.dart';
import 'package:catalog_app/features/data/models/product_model.dart';
import 'package:dio/dio.dart';

abstract class ProductRemoteDatasource {
  Future<List<ProductModel>> getProducts();

  Future<ProductModel> getProductById(int id);

  Future<ProductModel> addProduct(ProductModel product);
}

class ProductRemoteDatasourceImpl implements ProductRemoteDatasource {

  final Dio dio;

  ProductRemoteDatasourceImpl(this.dio);

  @override
  Future<List<ProductModel>> getProducts() async {
    try {
      final response = await dio.get('/products');
      final List data = response.data;
      return data.map((json) => ProductModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Server error');
    }
  }

  @override
  Future<ProductModel> getProductById(int id) async {
    try {
      final response = await dio.get('/products/$id');
      return ProductModel.fromJson(response.data);
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Server error');
    }
  }

  @override
  Future<ProductModel> addProduct(ProductModel product) async {
    try {
      final response = await dio.post(
        '/products',
        data: product.toJson(),
      );
      return ProductModel.fromJson(response.data);
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Server error');
    }
  }
}
