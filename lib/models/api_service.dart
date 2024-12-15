import 'package:dio/dio.dart';
import 'note.dart';

class ApiService {
  final Dio _dio = Dio();

  Future<List<Note>> getItems() async {
    try {
      final response = await _dio.get('http://192.168.1.52:8080/items');
      if (response.statusCode == 200) {
        return (response.data as List)
            .map((item) => Note.fromJson(item))
            .toList();
      } else {
        throw Exception('Failed to load items');
      }
    } catch (e) {
      throw Exception('Error fetching items: $e');
    }
  }
}
