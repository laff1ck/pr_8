import 'package:flutter/material.dart';
import '../models/note.dart';

class CartPage extends StatelessWidget {
  final List<Note> cartItems;

  const CartPage({Key? key, required this.cartItems}) : super(key: key);

  // Подсчет общей стоимости товаров в корзине
  double _calculateTotalPrice() {
    return cartItems.fold(0.0, (sum, item) => sum + item.price);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Корзина')),
      body: Column(
        children: [
          // Список товаров в корзине
          Expanded(
            child: cartItems.isEmpty
                ? const Center(child: Text('Корзина пуста'))
                : ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index];
                return ListTile(
                  leading: item.photo_id.isNotEmpty
                      ? Image.network(
                    item.photo_id,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  )
                      : const Icon(Icons.image_not_supported),
                  title: Text(item.title),
                  subtitle: Text('₽${item.price.toStringAsFixed(2)}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.remove_circle),
                    onPressed: () {
                      // Логика удаления товара
                      cartItems.removeAt(index);
                      (context as Element).reassemble(); // Обновляем экран
                    },
                  ),
                );
              },
            ),
          ),
          // Суммарная стоимость
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: Colors.grey.shade300),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Общая стоимость:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  '₽${_calculateTotalPrice().toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}