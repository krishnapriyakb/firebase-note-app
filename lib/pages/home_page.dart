import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_test/services/firestore.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirestoreService firestoreService = FirestoreService();
  TextEditingController textController = TextEditingController();

  void openNoteBox(String? docID) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: TextField(
                decoration: const InputDecoration(
                    hintText: "Type here..",
                    hintTextDirection: TextDirection.ltr),
                controller: textController,
              ),
              actions: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink[100],
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onPressed: () async {
                    if (docID == null) {
                      await firestoreService.addNote(textController.text);
                    } else {
                      await firestoreService.updateNote(
                          docID, textController.text);
                    }

                    textController.clear();
                    Navigator.pop(context);
                  },
                  child:
                      docID == null ? const Text("Add") : const Text("Update"),
                )
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          openNoteBox(null);
        },
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: firestoreService.getNotesStream(),
          builder: (context, snapshot) {
            //if we have data get all the docs
            if (snapshot.hasData) {
              List notesList = snapshot.data!.docs;

              //display data as a list
              return ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: notesList.length,
                  itemBuilder: (context, index) {
                    //get each individual doc
                    DocumentSnapshot document = notesList[index];
                    String docID = document.id;

                    //get note from each doc

                    Map<String, dynamic> data =
                        document.data() as Map<String, dynamic>;
                    String noteText = data['note'];

                    //display as listtile
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        tileColor: Colors.indigo[100],
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                                onPressed: () {
                                  openNoteBox(docID);
                                },
                                icon: const Icon(Icons.edit)),
                            IconButton(
                                onPressed: () async {
                                  await firestoreService.deleteNote(docID);
                                },
                                icon: const Icon(Icons.delete))
                          ],
                        ),
                        title: Text(noteText),
                      ),
                    );
                  });
            } else {
              return const Center(child: Text("no notes"));
            }
          }),
      appBar: AppBar(
        centerTitle: true,
        title: const Text("N O T E S"),
      ),
    );
  }
}
