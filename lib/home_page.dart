import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'models/task_model.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _controller = TextEditingController();
  DateTime? _selectedDate;
  DateTime _focusedDay = DateTime.now();

  User? get user => FirebaseAuth.instance.currentUser;

  CollectionReference get tasksCollection =>
      FirebaseFirestore.instance.collection('tasks');

  void _addTask() {
    final title = _controller.text.trim();
    if (title.isNotEmpty && user != null && _selectedDate != null) {
      tasksCollection.add({
        'title': title,
        'isDone': false,
        'uid': user!.uid,
        'date': _selectedDate,
      });
      _controller.clear();
      setState(() {
        _selectedDate = null;
      });
    }
  }

  void _toggleDone(Task task) {
    tasksCollection.doc(task.id).update({'isDone': !task.isDone});
  }

  void _deleteTask(Task task) {
    tasksCollection.doc(task.id).delete();
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return const Scaffold(
        body: Center(child: Text("User not authenticated")),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Row(
          children: [
            const Icon(Icons.school, color: Colors.white),
            const SizedBox(width: 10),
            const Text(
              "Daily Planner",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
                color: Colors.white,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDate, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDate = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            calendarStyle: const CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Colors.deepPurple,
                shape: BoxShape.circle,
              ),
            ),
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  tasksCollection
                      .where('uid', isEqualTo: user!.uid)
                      .orderBy('date')
                      .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: Text('Error loading tasks'));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final taskDocs = snapshot.data?.docs ?? [];
                final tasks =
                    taskDocs
                        .map(
                          (doc) => Task.fromMap(
                            doc.data() as Map<String, dynamic>,
                            doc.id,
                          ),
                        )
                        .toList();

                if (tasks.isEmpty) {
                  return const Center(child: Text('No tasks yet.'));
                }

                return ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final task = tasks[index];
                    return Card(
                      color: task.isDone ? Colors.green[100] : Colors.blue[100],
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12.0,
                        vertical: 6.0,
                      ),
                      child: ListTile(
                        leading: Icon(
                          task.isDone ? Icons.task_alt : Icons.sync,
                        ),
                        title: Text(
                          task.title,
                          style: TextStyle(
                            decoration:
                                task.isDone ? TextDecoration.lineThrough : null,
                          ),
                        ),
                        trailing: Wrap(
                          spacing: 12,
                          children: [
                            Checkbox(
                              value: task.isDone,
                              onChanged: (_) => _toggleDone(task),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => _deleteTask(task),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _controller,
                  maxLength: 20,
                  decoration: InputDecoration(
                    hintText: 'Add To-Do List Item',
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => _controller.clear(),
                    ),
                    border: const OutlineInputBorder(),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _selectedDate != null
                          ? DateFormat.yMMMd().format(_selectedDate!)
                          : 'No date selected',
                      style: const TextStyle(fontSize: 14),
                    ),
                    IconButton(
                      icon: const Icon(Icons.calendar_today),
                      onPressed:
                          () => setState(() {
                            _selectedDate = DateTime.now();
                          }),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _addTask,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    child: const Text("Add To-Do Item"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
