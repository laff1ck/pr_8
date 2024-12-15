import 'package:flutter/material.dart';
import '../models/note.dart';

class CreateNotePage extends StatefulWidget {
  final Function(Note) onCreate;

  const CreateNotePage({Key? key, required this.onCreate}) : super(key: key);

  @override
  _CreateNotePageState createState() => _CreateNotePageState();
}

class _CreateNotePageState extends State<CreateNotePage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _urlController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  void _saveNote() {
    if (_titleController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        _urlController.text.isEmpty ||
        _priceController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Пожалуйста, заполните все поля')),
      );
      return;
    }

    final price = double.tryParse(_priceController.text);
    if (price == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Цена должна быть числом')),
      );
      return;
    }

    final urlPattern = r'^(http|https):\/\/';
    if (!RegExp(urlPattern).hasMatch(_urlController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Введите действительный URL изображения')),
      );
      return;
    }

    final newNote = Note(
      id: DateTime.now().millisecondsSinceEpoch,
      title: _titleController.text,
      description: _descriptionController.text,
      photo_id: _urlController.text,
      price: price,
    );

    widget.onCreate(newNote);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Создать заметку'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Заголовок'),
                keyboardType: TextInputType.text
            ),
            TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Описание'),
                keyboardType: TextInputType.text
            ),
            TextField(
              controller: _urlController,
              decoration: const InputDecoration(labelText: 'URL изображения'),
            ),
            TextField(
              controller: _priceController,
              decoration: const InputDecoration(labelText: 'Цена'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveNote,
              child: const Text('Сохранить заметку'),
            ),
          ],
        ),
      ),
    );
  }
}