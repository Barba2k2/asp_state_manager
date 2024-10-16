class ShoppingItem {
  final String name;
  final String category;
  final bool isUrgent;
  final int purchaseCount;
  final double? price;
  final String priceType; // Novo campo para tipo de preço

  ShoppingItem({
    required this.name,
    required this.category,
    this.isUrgent = false,
    this.purchaseCount = 0,
    this.price,
    required this.priceType,
  });

  ShoppingItem toggleUrgent() {
    return ShoppingItem(
      name: name,
      category: category,
      isUrgent: !isUrgent,
      purchaseCount: purchaseCount,
      price: price,
      priceType: priceType,
    );
  }

  ShoppingItem incrementPurchaseCount() {
    return ShoppingItem(
      name: name,
      category: category,
      isUrgent: isUrgent,
      purchaseCount: purchaseCount + 1,
      price: price,
      priceType: priceType,
    );
  }

  String toSerializedString() {
    return '$name::$category::$isUrgent::$purchaseCount::${price ?? 0.0}::$priceType';
  }

  static ShoppingItem fromSerializedString(String serialized) {
    final split = serialized.split('::');
    return ShoppingItem(
      name: split[0],
      category: split[1],
      isUrgent: split[2] == 'true',
      purchaseCount: int.parse(split[3]),
      price: double.parse(split[4]),
      priceType: split[5],
    );
  }
}
