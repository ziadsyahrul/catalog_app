import 'package:equatable/equatable.dart';

abstract class ProductDetailEvent extends Equatable {
  const ProductDetailEvent();

  @override
  List<Object?> get props => [];
}

class GetProductDetailEvent extends ProductDetailEvent {
  final int id;
  const GetProductDetailEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class ToggleFavoriteEvent extends ProductDetailEvent {
  final int productId;
  const ToggleFavoriteEvent(this.productId);

  @override
  List<Object?> get props => [productId];
}