
import 'package:flutter/material.dart';
import '../models/note.dart';

class FavoritesPage extends StatelessWidget {
  final List<Note> favoriteNotes;
  final Function(Note) onToggleFavorite;

  const FavoritesPage({
    Key? key,
    required this.favoriteNotes,
    required this.onToggleFavorite,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Избранное'),
      ),
      body: ListView.builder(
        itemCount: favoriteNotes.length,
        itemBuilder: (context, index) {
          final note = favoriteNotes[index];
          return GestureDetector(
            onTap: () {
              // Открытие экрана заметки, если требуется
            },
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (note.photo_id.isNotEmpty)
                        Image.network(
                          note.photo_id,
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Text('Ошибка загрузки изображения');
                          },
                        ),
                      const SizedBox(height: 10),
                      Text(
                        note.title,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.black),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        note.description,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.black87),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        '₽${note.price}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.black),
                      ),
                    ],
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: IconButton(
                      icon: Icon(
                        note.isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: note.isFavorite ? Colors.red : Colors.grey,
                      ),
                      onPressed: () {
                        onToggleFavorite(note); // Уведомляем родительский виджет
                      },
                    ),



                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}