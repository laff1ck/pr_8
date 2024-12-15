class Service {
  final String title;
  final String price;
  final String duration;
  int quantity;

  Service({
    required this.title,
    required this.price,
    required this.duration,
    this.quantity = 0,
  });
}