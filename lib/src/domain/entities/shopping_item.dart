class ShoppingItem {
  final int? id;
  final String name;
  final String category;
  final bool isUrgent;
  final int purchaseCount;
  final double? price;
  final String priceType;

  ShoppingItem({
    this.id,
    required this.name,
    required this.category,
    this.isUrgent = false,
    this.purchaseCount = 0,
    this.price,
    required this.priceType,
  });

  ShoppingItem toggleUrgent() {
    return copyWith(isUrgent: !isUrgent);
  }

  ShoppingItem incrementPurchaseCount() {
    return copyWith(purchaseCount: purchaseCount + 1);
  }

  ShoppingItem copyWith({
    int? id,
    String? name,
    String? category,
    bool? isUrgent,
    int? purchaseCount,
    double? price,
    String? priceType,
  }) {
    return ShoppingItem(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      isUrgent: isUrgent ?? this.isUrgent,
      purchaseCount: purchaseCount ?? this.purchaseCount,
      price: price ?? this.price,
      priceType: priceType ?? this.priceType,
    );
  }

  String toSerializedString() {
    return '$id::$name::$category::$isUrgent::$purchaseCount::${price ?? 0.0}::$priceType';
  }

  static ShoppingItem fromSerializedString(String serialized) {
    final split = serialized.split('::');
    return ShoppingItem(
      id: split[0].isNotEmpty ? int.tryParse(split[0]) : null,
      name: split[1],
      category: split[2],
      isUrgent: split[3] == 'true',
      purchaseCount: int.parse(split[4]),
      price: double.parse(split[5]),
      priceType: split[6],
    );
  }
}
