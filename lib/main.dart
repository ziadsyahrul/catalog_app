import 'package:catalog_app/core/di/injection.dart';
import 'package:catalog_app/core/local/hive_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/router/app_router.dart';
import 'features/presentation/bloc/favorite/favorite_bloc.dart';
import 'features/presentation/bloc/product_detail/product_detail_bloc.dart';
import 'features/presentation/bloc/product_list/product_list_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveClient.init();
  await initDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<ProductListBloc>()),
        BlocProvider(create: (_) => sl<ProductDetailBloc>()),
        BlocProvider(create: (_) => sl<FavoriteBloc>()),
      ],
      child: MaterialApp.router(
        title: 'Product Catalog',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        routerConfig: AppRouter.router,
      ),
    );
  }
}
