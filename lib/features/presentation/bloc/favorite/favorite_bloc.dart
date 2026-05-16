import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/get_favorite_products.dart';
import 'favorite_event.dart';
import 'favorite_state.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  final GetFavoriteProducts getFavoriteProducts;

  FavoriteBloc({required this.getFavoriteProducts}) : super(FavoriteInitial()) {
    on<GetFavoriteProductsEvent>(_onGetFavorites);
  }

  Future<void> _onGetFavorites(
      GetFavoriteProductsEvent event,
      Emitter<FavoriteState> emit,
      ) async {
    emit(FavoriteLoading());
    try {
      await emit.forEach(
        getFavoriteProducts(),
        onData: (favorites) => FavoriteLoaded(favorites),
        onError: (error, _) => FavoriteError(error.toString()),
      );
    } catch (e) {
      emit(FavoriteError(e.toString()));
    }
  }
}