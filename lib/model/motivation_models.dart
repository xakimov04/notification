
class MotivationModel {
  final String quote;
  final String author;

  MotivationModel({required this.quote, required this.author});

  factory MotivationModel.fromJson(Map<String, dynamic> json) {
    return MotivationModel(
      quote: json['quote'] ?? 'No quote available',
      author: json['author'] ?? 'Unknown author',
    );
  }
}