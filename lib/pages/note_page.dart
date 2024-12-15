import 'package:flutter/material.dart';
import 'package:pr_8/models/note.dart';

class NotePage extends StatelessWidget {
  final Note note;

  const NotePage({required this.note});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(note.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (note.photo_id.isNotEmpty)
              Image.network(
                note.photo_id,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Text('Ошибка загрузки изображения');
                },
              ),


            SizedBox(height: 16.0),
            Text(note.description),
          ],
        ),
      ),
    );
  }
}