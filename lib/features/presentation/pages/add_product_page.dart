import 'package:catalog_app/features/presentation/bloc/product_list/product_list_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entities/product.dart';
import '../bloc/product_list/product_list_bloc.dart';
import '../bloc/product_list/product_list_event.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _categoryController = TextEditingController();
  final _imageController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    _imageController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final product = Product(
        id: 0,
        // API yang generate id
        title: _titleController.text,
        price: double.parse(_priceController.text),
        description: _descriptionController.text,
        category: _categoryController.text,
        image: _imageController.text,
      );
      context.read<ProductListBloc>().add(AddProductEvent(product));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Produk')),
      body: BlocListener<ProductListBloc, ProductListState>(
        listener: (context, state) {
          if (state is ProductAdded) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Produk berhasil ditambahkan!')),
            );
            context.pop(); // back to home
          }
          if (state is ProductListError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: 'Nama Produk'),
                  validator: (value) =>
                      value!.isEmpty ? 'Nama produk wajib diisi' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _priceController,
                  decoration: const InputDecoration(labelText: 'Harga'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty) return 'Harga wajib diisi';
                    if (double.tryParse(value) == null)
                      return 'Harga tidak valid';
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: 'Deskripsi'),
                  maxLines: 3,
                  validator: (value) =>
                      value!.isEmpty ? 'Deskripsi wajib diisi' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _categoryController,
                  decoration: const InputDecoration(labelText: 'Kategori'),
                  validator: (value) =>
                      value!.isEmpty ? 'Kategori wajib diisi' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _imageController,
                  decoration: const InputDecoration(labelText: 'URL Gambar'),
                  validator: (value) =>
                      value!.isEmpty ? 'URL gambar wajib diisi' : null,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    child: const Text('Tambah Produk'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
