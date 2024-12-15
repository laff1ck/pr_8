import 'package:flutter/material.dart';
import 'service.dart';



class Cart extends ChangeNotifier {
  final List<Service> _items = [];

  List<Service> get items => _items;

  void addItem(Service service) {
    final existingService = _items.firstWhere(
          (item) => item.title == service.title,
      orElse: () => Service(
        title: service.title,
        price: service.price,
        duration: service.duration,
        quantity: 0,
      ),
    );


    if (existingService.quantity == 0) {
      existingService.quantity = 1;
      _items.add(existingService);
    } else {
      existingService.quantity++;
    }

    notifyListeners();
  }

  void removeItem(Service service) {
    final existingService = _items.firstWhere(
          (item) => item.title == service.title,
      orElse: () => Service(title: '', price: '', duration: '', quantity: 0),
    );

    if (existingService.title.isNotEmpty && existingService.quantity > 0) {
      existingService.quantity--;
      if (existingService.quantity == 0) {
        _items.remove(existingService);
      }
    }

    notifyListeners();
  }

  int get totalPrice {
    return _items.fold(0, (sum, item) => sum + int.parse(item.price.replaceAll(' ₽', '').trim()) * item.quantity);
  }
}