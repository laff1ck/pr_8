import 'package:flutter/material.dart';
import '../models/note.dart';

class ItemNote extends StatefulWidget {
  final Note note;
  final Function(Note) onAddToCart;
  final List<Note> cartItems;

  const ItemNote({
    Key? key,
    required this.note,
    required this.onAddToCart,
    required this.cartItems,
  }) : super(key: key);

  @override
  _ItemNoteState createState() => _ItemNoteState();
}

class _ItemNoteState extends State<ItemNote> {
  // Функция для переключения избранного состояния
  void _toggleFavorite() {
    setState(() {
      widget.note.isFavorite = !widget.note.isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.note.title),
        actions: [
          IconButton(
            icon: Icon(
              Icons.shopping_cart,
              color: widget.cartItems.isNotEmpty ? Colors.green : Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CartPage(cartItems: widget.cartItems), // Переход на экран корзины
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(
              widget.note.isFavorite ? Icons.favorite : Icons.favorite_border,
              color: widget.note.isFavorite ? Colors.red : Colors.white,
            ),
            onPressed: _toggleFavorite,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.note.photo_id.isNotEmpty)
              Image.network(
                widget.note.photo_id,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Text('Ошибка загрузки изображения');
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                          (loadingProgress.expectedTotalBytes ?? 1)
                          : null,
                    ),
                  );
                },
              ),
            const SizedBox(height: 10),
            Text(widget.note.description),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                widget.onAddToCart(widget.note);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Добавлено в корзину')),
                );
              },
              icon: const Icon(Icons.add_shopping_cart),
              label: const Text('Добавить в корзину'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Страница корзины (CartPage)
class CartPage extends StatelessWidget {
  final List<Note> cartItems;

  const CartPage({Key? key, required this.cartItems}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Корзина')),
      body: cartItems.isEmpty
          ? const Center(child: Text('Корзина пуста'))
          : ListView.builder(
        itemCount: cartItems.length,
        itemBuilder: (context, index) {
          final item = cartItems[index];
          return ListTile(
            leading: item.photo_id.isNotEmpty
                ? Image.network(item.photo_id, width: 50, height: 50, fit: BoxFit.cover)
                : const Icon(Icons.image_not_supported),
            title: Text(item.title),
            subtitle: Text('₽${item.price}'),
            trailing: IconButton(
              icon: const Icon(Icons.remove_circle),
              onPressed: () {
                // Логика удаления из корзины
                cartItems.removeAt(index);
              },
            ),
          );
        },
      ),
    );
  }
}