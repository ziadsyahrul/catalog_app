import 'package:catalog_app/features/presentation/bloc/product_list/product_list_bloc.dart';
import 'package:catalog_app/features/presentation/bloc/product_list/product_list_event.dart';
import 'package:catalog_app/features/presentation/bloc/product_list/product_list_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../widgets/product_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    context.read<ProductListBloc>().add(GetProductsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Catalog'),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () => context.push('/favorite'),
          ),
        ],
      ),
      // BlocBuilder = collectAsState() di Android
      body: BlocBuilder<ProductListBloc, ProductListState>(
        builder: (context, state) {
          if (state is ProductListLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ProductListError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.message),
                  ElevatedButton(
                    onPressed: () => context.read<ProductListBloc>()
                        .add(GetProductsEvent()),
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            );
          }

          if (state is ProductListLoaded) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<ProductListBloc>().add(GetProductsEvent());
              },
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.7,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: state.products.length,
                itemBuilder: (context, index) {
                  final product = state.products[index];
                  return ProductCard(
                    product: product,
                    onTap: () => context.push('/detail/${product.id}'),
                  );
                },
              ),
            );
          }

          return const SizedBox();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/add-product'),
        child: const Icon(Icons.add),
      ),
    );
  }
}