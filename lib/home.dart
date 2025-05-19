import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'node_model.dart'; // Make sure this file exists and is correct

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final titleController = TextEditingController();
  final descController = TextEditingController();

  List<Note> notes = [];

  @override
  void initState() {
    super.initState();
    getNotes(); // Load notes when the app starts
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        leading: Icon(Icons.home, color: Colors.white),
        title: Text("Notes App", style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            onPressed: () {
              getNotes(); // Manual refresh
            },
            icon: Icon(Icons.refresh, color: Colors.white),
          ),
        ],
      ),
      body:
          notes.isEmpty
              ? Center(
                child: Text(
                  "No Notes Yet",
                  style: TextStyle(fontSize: 20, color: Colors.black),
                ),
              )
              : ListView.builder(
                itemCount: notes.length,
                itemBuilder: (context, index) {
                  Note note = notes[index];
                  return ListTile(
                    leading: CircleAvatar(
                      child: Text(
                        note.title[0].toUpperCase(),
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    title: Text(note.title),
                    subtitle: Text(note.desc),
                  );
                },
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder:
                (context) => AlertDialog(
                  title: Text("Add Note", style: TextStyle(fontSize: 20)),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: titleController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Enter Title",
                        ),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: descController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Enter Description",
                        ),
                      ),
                    ],
                  ),
                  actions: [
                    OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        String title = titleController.text.trim();
                        String desc = descController.text.trim();
                        if (title.isNotEmpty && desc.isNotEmpty) {
                          Note newNote = Note(title: title, desc: desc);
                          titleController.clear();
                          descController.clear();
                          await addNote(newNote, context);
                          await getNotes(); // Refresh list after add
                          Navigator.pop(context);
                        }
                      },
                      child: Text('Add', style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                      ),
                    ),
                  ],
                ),
          );
        },
        child: Icon(Icons.add, color: Colors.white),
        backgroundColor: Colors.blueAccent,
      ),
    );
  }

  Future<void> addNote(Note note, BuildContext context) async {
    FirebaseFirestore db = FirebaseFirestore.instance;

    await db
        .collection("Notes")
        .doc(DateTime.now().toString())
        .set(Note.toMap(note))
        .then((_) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("Added Successfully")));
        })
        .catchError((error) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("Failed to add note: $error")));
        });
  }

  Future<void> getNotes() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    await db
        .collection("Notes")
        .get()
        .then((value) {
          notes.clear(); // Clear old list before adding new
          for (var doc in value.docs) {
            notes.add(Note.fromMap(doc.data()));
          }
          setState(() {}); // Update UI
        })
        .catchError((error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Failed to fetch notes: $error")),
          );
        });
  }
}
