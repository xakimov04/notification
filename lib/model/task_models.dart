import 'package:cloud_firestore/cloud_firestore.dart';

class TaskModels {
  String id;
  String title;
  String description;
  bool isDone;
  String time;

  TaskModels({
    required this.id,
    required this.title,
    required this.description,
    required this.time,
    required this.isDone,
  });
  TaskModels copyWith({
    String? description,
  }) {
    return TaskModels(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      time: time ?? this.time,
      isDone: isDone ?? this.isDone,
    );
  }

  factory TaskModels.fromSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return TaskModels(
      id: doc.id,
      title: data['title'],
      description: data['description'],
      time: data['time'],
      isDone: data['isDone'],
    );
  }
}
