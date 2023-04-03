import 'package:equatable/equatable.dart';

// Simple class to represent NewsItems
class NewsItem extends Equatable {
  final String id;
  final String title;
  final String body;
  final String author;
  final DateTime date;
  final String image;
  bool isRead;
  bool isSavedForLater;

  NewsItem({
    required this.id,
    required this.title,
    required this.body,
    required this.author,
    required this.date,
    required this.image,
    this.isRead = false,
    this.isSavedForLater = false,
  });


  // Return a copy of the newsItem but with the read flag set to true
  NewsItem readVersion() {
    return NewsItem(
      id: id,
      title: title,
      body: body,
      author: author,
      date: date,
      image: image,
      isRead: true,
    );
  }

  // Factory method to parse JSON data
  factory NewsItem.fromJson(Map<String, dynamic> json) {
    return NewsItem(
      id: json['id'],
      title: json['title'],
      body: json['body'],
      author: json['author'],
      date: DateTime.parse(json['date']),
      image: json['image'],
      isRead: json['isRead'] ?? false,
    );
  }

  // Convert this object to JSON
  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'body': body,
    'author': author,
    'date': date.toIso8601String(),
    'image': image,
    'isRead': isRead,
  };


  // Properties involved in the override for == and hashCode
  @override
  List<Object?> get props => [id, title, body, author, date, image, isRead];

  // Equatable library convert this object to a string
  bool get stringify => true;
}
