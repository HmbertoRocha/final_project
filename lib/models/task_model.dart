// Import Firestore package to handle Timestamp type
import 'package:cloud_firestore/cloud_firestore.dart';

// Task model representing a to-do item
class Task {
  // Unique document ID from Firestore
  String id;

  // Title of the task
  String title;

  // Boolean indicating whether the task is completed
  bool isDone;

  // The date associated with the task
  DateTime date;

  // Constructor to initialize Task object
  Task({
    required this.id,
    required this.title,
    required this.isDone,
    required this.date,
  });

  // Factory constructor to create a Task object from Firestore map and document ID
  factory Task.fromMap(Map<String, dynamic> map, String documentId) {
    return Task(
      id: documentId,
      title: map['title'] ?? '', // Provide empty string if title is missing
      isDone: map['isDone'] ?? false, // Default to false if isDone is missing
      date:
          (map['date'] as Timestamp)
              .toDate(), // Convert Firestore Timestamp to DateTime
    );
  }

  // Converts a Task object into a map for saving to Firestore
  Map<String, dynamic> toMap() {
    return {'title': title, 'isDone': isDone, 'date': date};
  }
}
