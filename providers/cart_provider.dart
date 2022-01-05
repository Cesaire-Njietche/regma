import 'package:flutter/material.dart';

class CartItemModel {
  final String id;
  final String productId; //To trace bought items
  final String productName;
  final String productImage;
  final double price;
  final int quantity;

  CartItemModel({
    @required this.id,
    @required this.productId,
    @required this.productImage,
    @required this.price,
    @required this.productName,
    @required this.quantity,
  });
}

class CartProvider with ChangeNotifier {
  Map<String, CartItemModel> _items = {};

  Map<String, CartItemModel> get items => {..._items};

  int count() => _items.length;

  bool addItem(String id, String title, String image, double price) {
    if (_items.containsKey(id)) {
      return false;
    }
    _items.putIfAbsent(
      id,
      () => CartItemModel(
        id: DateTime.now().toString(),
        productId: id,
        productImage: image,
        price: price,
        productName: title,
        quantity: 1,
      ),
    );
    notifyListeners();
    return true;
  }

  double get total {
    double total = 0;
    _items.forEach((key, value) {
      total += value.price;
    });

    return total;
  }

  // void increaseQuantity(String id) {
  //   _items.update(
  //     id,
  //     (value) => CartItem(
  //       id: value.id,
  //       productId: id,
  //       productImage: value.productImage,
  //       price: value.price,
  //       productName: value.productName,
  //       quantity: value.quantity + 1,
  //     ),
  //   );
  //   notifyListeners();
  // }
  //
  // void decreaseQuantity(String id) {
  //   _items.update(
  //     id,
  //     (value) => CartItem(
  //       id: value.id,
  //       productId: id,
  //       productImage: value.productImage,
  //       price: value.price,
  //       productName: value.productName,
  //       quantity: value.quantity - 1,
  //     ),
  //   );
  //   notifyListeners();
  // }

  void removeItem(String id) {
    _items.remove(id);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
