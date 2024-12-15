import 'package:flutter/material.dart';
import '../models/note.dart';
import '../models/api_service.dart';
import '../components/item_note.dart' as components;
import 'create_note_page.dart' as pages;

class HomePage extends StatefulWidget {
  final Function(Note) onToggleFavorite;
  final Function(Note) onAddNote;
  final Function(Note) onDeleteNote;
  final List<Note> cartItems;
  final Function(Note) onAddToCart;

  const HomePage({
    Key? key,
    required this.onToggleFavorite,
    required this.onAddNote,
    required this.onDeleteNote,
    required this.cartItems,
    required this.onAddToCart,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Note>> _notesFuture;

  @override
  void initState() {
    super.initState();
    _loadNotes(); // Инициализация загрузки данных
  }

  void _loadNotes() {
    setState(() {
      _notesFuture = ApiService().getItems(); // Загрузка данных из API
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Лавочка'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadNotes, // Обновить данные
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) =>
                      pages.CreateNotePage(onCreate: widget.onAddNote),
                ),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Note>>(
        future: _notesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator()); // Индикатор загрузки
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Ошибка загрузки данных: ${snapshot.error}',
                textAlign: TextAlign.center,
              ), // Ошибка
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'Нет доступных квартир',
                style: TextStyle(fontSize: 18),
              ), // Пустой список
            );
          } else {
            final notes = snapshot.data!;
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Количество колонок
                childAspectRatio: 0.6, // Пропорции
                crossAxisSpacing: 10.0, // Расстояние между колонками
                mainAxisSpacing: 10.0, // Расстояние между строками
              ),
              padding: const EdgeInsets.all(10),
              itemCount: notes.length,
              itemBuilder: (context, index) {
                final note = notes[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => components.ItemNote(
                          note: note,
                          onAddToCart: widget.onAddToCart,
                          cartItems: widget.cartItems,
                        ),
                      ),
                    );
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (note.photo_id.isNotEmpty)
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(12),
                            ),
                            child: Image.network(
                              note.photo_id,
                              height: 150,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Center(
                                  child: Text('Ошибка загрузки изображения'),
                                );
                              },
                            ),
                          ),
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            note.title,
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            '₽${note.price.toStringAsFixed(2)}',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            note.description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: Icon(
                                note.isFavorite ? Icons.favorite : Icons.favorite_border,
                                color: note.isFavorite ? Colors.red : Colors.grey,
                              ),
                              onPressed: () {
                                setState(() {
                                  note.isFavorite = !note.isFavorite; // Локальное обновление состояния
                                });
                                widget.onToggleFavorite(note); // Обновление глобального состояния
                              },
                            ),



                            IconButton(
                              icon: const Icon(Icons.add_shopping_cart),
                              onPressed: () {
                                widget.onAddToCart(note);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}