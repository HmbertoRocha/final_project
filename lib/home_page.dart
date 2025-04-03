// Import Firestore to interact with cloud database
import 'package:cloud_firestore/cloud_firestore.dart';
// Import FirebaseAuth to manage authentication
import 'package:firebase_auth/firebase_auth.dart';
// Import Flutter's UI framework
import 'package:flutter/material.dart';
// Import calendar widget package
import 'package:table_calendar/table_calendar.dart';
// Import custom model for task
import 'models/task_model.dart';
// Import to format date
import 'package:intl/intl.dart';

// Main HomePage widget which is stateful (because it needs to update UI dynamically)
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Controller for the input text field
  final TextEditingController _controller = TextEditingController();

  // Selected date on calendar
  DateTime? _selectedDate;

  // Currently focused date on calendar
  DateTime _focusedDay = DateTime.now();

  // Gets the current logged-in user
  User? get user => FirebaseAuth.instance.currentUser;

  // Reference to the 'tasks' collection in Firestore
  CollectionReference get tasksCollection =>
      FirebaseFirestore.instance.collection('tasks');

  // Adds a new task to Firestore with the selected date
  void _addTask() {
    final title = _controller.text.trim();
    if (title.isNotEmpty && user != null && _selectedDate != null) {
      tasksCollection.add({
        'title': title,
        'isDone': false,
        'uid': user!.uid,
        'date': _selectedDate,
      });
      _controller.clear(); // Clear the input field
      FocusScope.of(context).unfocus(); // Dismisses the keyboard
      setState(() {
        _selectedDate = null; // Reset the selected date
      });
    }
  }

  // Toggles the completion status of a task
  void _toggleDone(Task task) {
    tasksCollection.doc(task.id).update({'isDone': !task.isDone});
  }

  // Deletes a task from Firestore
  void _deleteTask(Task task) {
    tasksCollection.doc(task.id).delete();
  }

  @override
  Widget build(BuildContext context) {
    // Displays a fallback screen if user is not logged in
    if (user == null) {
      return const Scaffold(
        body: Center(child: Text("User not authenticated")),
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: true, // Prevents keyboard overflow
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('images/red_deer_logo.png', height: 90),
            const SizedBox(width: 12),
            const Text(
              "Daily Planner",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
                color: Colors.black,
              ),
            ),
          ],
        ),
        actions: [
          // Logout button
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 12,
          left: 12,
          right: 12,
          top: 12,
        ),
        child: Column(
          children: [
            // Calendar widget to select date
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

            const SizedBox(height: 12),

            // Task list section
            SizedBox(
              height: 300, // Fixed height to allow space for keyboard
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
                        color:
                            task.isDone ? Colors.green[100] : Colors.blue[100],
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
                                  task.isDone
                                      ? TextDecoration.lineThrough
                                      : null,
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

            // Input for new task
            const SizedBox(height: 12),
            TextField(
              controller: _controller,
              maxLength: 20,
              autofocus: true,
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
          ],
        ),
      ),
      // Button moved to bottomNavigationBar to prevent keyboard overflow
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 8,
          left: 12,
          right: 12,
        ),
        child: ElevatedButton(
          onPressed: _addTask,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            minimumSize: const Size.fromHeight(50),
          ),
          child: const Text("Add To-Do Item"),
        ),
      ),
    );
  }
}
