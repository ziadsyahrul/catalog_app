import 'package:catalog_app/core/local/hive_client.dart';
import 'package:catalog_app/core/network/dio_client.dart';
import 'package:catalog_app/features/data/datasources/product_local_datasource.dart';
import 'package:catalog_app/features/data/datasources/product_remote_datasource.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';

import '../../features/data/repositories/product_repository_impl.dart';
import '../../features/domain/repositories/product_repository.dart';
import '../../features/domain/usecases/add_product.dart';
import '../../features/domain/usecases/get_favorite_products.dart';
import '../../features/domain/usecases/get_product_detail.dart';
import '../../features/domain/usecases/get_products.dart';
import '../../features/domain/usecases/toggle_favorite.dart';
import '../../features/presentation/bloc/favorite/favorite_bloc.dart';
import '../../features/presentation/bloc/product_detail/product_detail_bloc.dart';
import '../../features/presentation/bloc/product_list/product_list_bloc.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // Hive Box
  final productBox = await HiveClient.openProductBox();
  final favoriteBox = await HiveClient.openFavoriteBox();
  sl.registerSingleton<Box>(productBox, instanceName: 'productBox');
  sl.registerSingleton<Box>(favoriteBox, instanceName: 'favoriteBox');

  //  Core
  sl.registerLazySingleton(() => DioClient());

  // ── DataSources ───────────────────────
  sl.registerLazySingleton<ProductRemoteDatasource>(
    () => ProductRemoteDatasourceImpl(sl<DioClient>().dio),
  );
  sl.registerLazySingleton<ProductLocalDataSource>(
    () => ProductLocalDataSourceImpl(
      productBox: sl<Box>(instanceName: 'productBox'),
      favoriteBox: sl<Box>(instanceName: 'favoriteBox'),
    ),
  );

  // ── Repository ────────────────────────
  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(remoteDataSource: sl(), localDataSource: sl()),
  );

  // ── UseCases ──────────────────────────
  sl.registerLazySingleton(() => GetProducts(sl()));
  sl.registerLazySingleton(() => GetProductDetail(sl()));
  sl.registerLazySingleton(() => AddProduct(sl()));
  sl.registerLazySingleton(() => ToggleFavorite(sl()));
  sl.registerLazySingleton(() => GetFavoriteProducts(sl()));

  sl.registerFactory(
    () => ProductListBloc(getProducts: sl(), addProduct: sl()),
  );

  sl.registerFactory(
    () => ProductDetailBloc(getProductDetail: sl(), toggleFavorite: sl()),
  );

  sl.registerFactory(() => FavoriteBloc(getFavoriteProducts: sl()));
}
