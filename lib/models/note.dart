class Note {
  final int id;
  final String title;
  final String description;
  final String photo_id;
  final double price;
  bool isFavorite;

  Note({
    required this.id,
    required this.title,
    required this.description,
    required this.photo_id,
    required this.price,
    this.isFavorite = false,
  });


  // Обработка JSON-ответа
  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['ID'] ?? 0,
      title: json['Name'] ?? 'Нет названия',
      description: json['Description'] ?? 'Описание отсутствует',
      photo_id: json['ImageLink'] ?? '', //
      price: (json['Price'] ?? 0).toDouble(),
      isFavorite: json['Favourite'] ?? false,
    );
  }
}