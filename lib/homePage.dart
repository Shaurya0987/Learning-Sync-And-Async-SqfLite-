import 'package:LearningLocalStorage/data/local/database.dart';
import 'package:flutter/material.dart';
import 'database_helper.dart'; // Import your database helper

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  List<Map<String, dynamic>> notes = [];

  @override
  void initState() {
    super.initState();
    _refreshNotes(); // Fetch notes when screen opens
  }

  // Fetch all notes from database
  Future<void> _refreshNotes() async {
    final data = await DatabaseHelper.instance.getAllNotes();
    setState(() {
      notes = data;
    });
  }

  // Add a new note
  Future<void> _addNote() async {
    TextEditingController titleController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add Note"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: "Title"),
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: "Description"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
              if (titleController.text.isNotEmpty &&
                  descriptionController.text.isNotEmpty) {
                // Insert into database
                await DatabaseHelper.instance.insert({
                  'title': titleController.text,
                  'description': descriptionController.text,
                });

                Navigator.pop(context); // Close dialog
                await _refreshNotes(); // Refresh UI
              }
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  // Delete a note
  Future<void> _deleteNote(int id) async {
    await DatabaseHelper.instance.Delete(id); // lowercase delete
    await _refreshNotes(); // Refresh after deletion
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Notes"),
        centerTitle: true,
        backgroundColor: Colors.orange.shade300,
      ),
      body: notes.isEmpty
          ? const Center(
              child: Text(
                "No Notes Yet! Tap + to add one...",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) {
                final note = notes[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  elevation: 3,
                  child: ListTile(
                    title: Text(
                      note['title'],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(note['description']),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteNote(note['id']),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNote,
        backgroundColor: Colors.orange,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
