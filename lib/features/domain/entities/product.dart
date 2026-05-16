class Product {
  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String image;
  final bool isFavorite;

  const Product({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
    this.isFavorite = false,
  });

  Product copyWith({
    int? id,
    String? title,
    double? price,
    String? description,
    String? category,
    String? image,
    bool? isFavorite,
  }) {
    return Product(
      id: id ?? this.id,
      title: title ?? this.title,
      price: price ?? this.price,
      description: description ?? this.description,
      category: category ?? this.category,
      image: image ?? this.image,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}