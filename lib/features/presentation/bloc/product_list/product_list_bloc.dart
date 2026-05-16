import 'package:catalog_app/features/presentation/bloc/product_list/product_list_event.dart';
import 'package:catalog_app/features/presentation/bloc/product_list/product_list_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/add_product.dart';
import '../../../domain/usecases/get_products.dart';

class ProductListBloc extends Bloc<ProductListEvent, ProductListState> {
  final GetProducts getProducts;
  final AddProduct addProduct;

  ProductListBloc({
    required this.getProducts,
    required this.addProduct,
  }) : super(ProductListInitial()) {
    on<GetProductsEvent>(_onGetProducts);
    on<AddProductEvent>(_onAddProduct);
  }

  Future<void> _onGetProducts(
      GetProductsEvent event,
      Emitter<ProductListState> emit,
      ) async {
    emit(ProductListLoading());
    try {
      final products = await getProducts();
      emit(ProductListLoaded(products));
    } catch (e) {
      emit(ProductListError(e.toString()));
    }
  }

  Future<void> _onAddProduct(
      AddProductEvent event,
      Emitter<ProductListState> emit,
      ) async {
    emit(ProductListLoading());
    try {
      final product = await addProduct(event.product);
      emit(ProductAdded(product));
      // refresh list setelah add
      add(GetProductsEvent());
    } catch (e) {
      emit(ProductListError(e.toString()));
    }
  }
}