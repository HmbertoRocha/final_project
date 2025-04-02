import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  String id;
  String title;
  bool isDone;
  DateTime date;

  Task({
    required this.id,
    required this.title,
    required this.isDone,
    required this.date,
  });

  factory Task.fromMap(Map<String, dynamic> map, String documentId) {
    return Task(
      id: documentId,
      title: map['title'] ?? '',
      isDone: map['isDone'] ?? false,
      date: (map['date'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {'title': title, 'isDone': isDone, 'date': date};
  }
}
