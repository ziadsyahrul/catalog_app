import 'package:catalog_app/features/presentation/bloc/favorite/favorite_bloc.dart';
import 'package:catalog_app/features/presentation/bloc/favorite/favorite_event.dart';
import 'package:catalog_app/features/presentation/bloc/favorite/favorite_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../widgets/product_card.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  @override
  void initState() {
    super.initState();
    context.read<FavoriteBloc>().add(GetFavoriteProductsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favorite')),
      body: BlocBuilder<FavoriteBloc, FavoriteState>(
        builder: (context, state) {

          print('FavoriteState: $state');

          if (state is FavoriteLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is FavoriteLoaded) {
            if (state.favorites.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.favorite_border, size: 80, color: Colors.grey),
                    SizedBox(height: 16),
                    Text('Belum ada produk favorite'),
                  ],
                ),
              );
            }

            return GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: state.favorites.length,
              itemBuilder: (context, index) {
                final product = state.favorites[index];
                return ProductCard(
                  product: product,
                  onTap: () => context.push('/detail/${product.id}'),
                );
              },
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}