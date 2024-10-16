class ShoppingItem {
  final String name;
  final String category;
  final bool isUrgent;
  final int purchaseCount;
  final double? price;

  ShoppingItem({
    required this.name,
    required this.category,
    this.isUrgent = false,
    this.purchaseCount = 0,
    this.price,
  });

  ShoppingItem toggleUrgent() {
    return ShoppingItem(
      name: name,
      category: category,
      isUrgent: !isUrgent,
      purchaseCount: purchaseCount,
      price: price,
    );
  }

  ShoppingItem incrementPurchaseCount() {
    return ShoppingItem(
      name: name,
      category: category,
      isUrgent: isUrgent,
      purchaseCount: purchaseCount + 1,
      price: price,
    );
  }

  String toSerializedString() {
    return '$name::$category::$isUrgent::$purchaseCount::${price ?? 0.0}';
  }

  static ShoppingItem fromSerializedString(String serialized) {
    final split = serialized.split('::');
    return ShoppingItem(
      name: split[0],
      category: split[1],
      isUrgent: split[2] == 'true',
      purchaseCount: int.parse(split[3]),
      price: double.parse(split[4]),
    );
  }
}
