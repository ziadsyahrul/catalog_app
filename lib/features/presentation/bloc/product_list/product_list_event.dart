import 'package:equatable/equatable.dart';

import '../../../domain/entities/product.dart';

abstract class ProductListEvent extends Equatable {
  const ProductListEvent();

  @override
  List<Object?> get props => [];
}

class GetProductsEvent extends ProductListEvent {}

class AddProductEvent extends ProductListEvent {
  final Product product;

  const AddProductEvent(this.product);

  @override
  List<Object?> get props => [product];
}
