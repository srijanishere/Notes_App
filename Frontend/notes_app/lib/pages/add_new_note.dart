import 'package:flutter/material.dart';
import 'package:notes_app/providers/note_provider.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../models/note.dart';

class AddNewNote extends StatefulWidget {
  final bool isUpdate;
  final Note? note;
  const AddNewNote({super.key, required this.isUpdate, this.note});

  @override
  State<AddNewNote> createState() => _AddNewNoteState();
}

class _AddNewNoteState extends State<AddNewNote> {
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  FocusNode noteFocus = FocusNode();

  void addNewNote() {
    Note note = Note(
      id: Uuid().v1(), //unique id will be assigned
      userid: "admin",
      title: titleController.text,
      content: contentController.text,
      dateadded: DateTime.now(),
    );

    Provider.of<NoteProvider>(context, listen: false).addNote(
        note); //if you're calling it outside a build function then listen: false needs to be mentioned
    Navigator.pop(context);
  }

  void updateNote() {
    widget.note!.title = titleController.text;
    widget.note!.content = contentController.text;
    widget.note!.dateadded = DateTime.now();
    Provider.of<NoteProvider>(context, listen: false).updateNote(widget.note!);
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    if (widget.isUpdate) {
      titleController.text = widget.note!.title!;
      contentController.text = widget.note!.content!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE6E7E9),
      appBar: AppBar(
        backgroundColor: Color(0xff0166B1),
        actions: [
          IconButton(
            onPressed: () {
              if (widget.isUpdate) {
                updateNote();
              } else {
                addNewNote();
              }
            },
            icon: Icon(
              Icons.check_circle_outlined,
              size: 30.0,
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              TextField(
                controller: titleController,
                autofocus: (widget.isUpdate) ? false : true,
                onSubmitted: (value) {
                  if (value != "") {
                    noteFocus
                        .requestFocus(); //used to switch to the contents TextField if a title is inputted and submitted
                  }
                },
                style: const TextStyle(
                  fontFamily: 'SpaceMono',
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: "Title",
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                        style: BorderStyle.solid,
                        color: Colors.black,
                        width: 3),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  // filled: true,
                  // fillColor: Color(0xffc0d59e),
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(
                        style: BorderStyle.solid,
                        color: Colors.black,
                        width: 3),
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Expanded(
                child: TextField(
                  controller: contentController,
                  focusNode: noteFocus,
                  maxLines: null,
                  style: const TextStyle(
                    fontFamily: 'SpaceMono',
                    fontSize: 15.0,
                  ),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: "Note",
                    // filled: true,
                    // fillColor: Color(0xffc0d59e),
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(style: BorderStyle.solid),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          style: BorderStyle.solid,
                          color: Colors.black,
                          width: 3),
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
