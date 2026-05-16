import 'package:catalog_app/features/presentation/bloc/product_detail/product_detail_event.dart';
import 'package:catalog_app/features/presentation/bloc/product_detail/product_detail_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/get_product_detail.dart';
import '../../../domain/usecases/toggle_favorite.dart';

class ProductDetailBloc extends Bloc<ProductDetailEvent, ProductDetailState> {
  final GetProductDetail getProductDetail;
  final ToggleFavorite toggleFavorite;

  ProductDetailBloc({
    required this.getProductDetail,
    required this.toggleFavorite,
  }) : super(ProductDetailInitial()) {
    on<GetProductDetailEvent>(_onGetProductDetail);
    on<ToggleFavoriteEvent>(_onToggleFavorite);
  }

  Future<void> _onGetProductDetail(
      GetProductDetailEvent event,
      Emitter<ProductDetailState> emit,
      ) async {
    emit(ProductDetailLoading());
    try {
      final product = await getProductDetail(event.id);
      emit(ProductDetailLoaded(product));
    } catch (e) {
      emit(ProductDetailError(e.toString()));
    }
  }

  Future<void> _onToggleFavorite(
      ToggleFavoriteEvent event,
      Emitter<ProductDetailState> emit,
      ) async {
    final currentState = state;

    try {
      await toggleFavorite(event.productId);
      if (currentState is ProductDetailLoaded) {
        final updatedProduct = currentState.product.copyWith(
          isFavorite: !currentState.product.isFavorite,
        );
        emit(ProductDetailLoaded(updatedProduct));
      }
    } catch (e) {
      emit(ProductDetailError(e.toString()));
    }
  }
}