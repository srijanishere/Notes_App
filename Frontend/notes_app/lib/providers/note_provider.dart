import 'package:flutter/material.dart';
import 'package:notes_app/models/note.dart';
import 'package:notes_app/services/api_service.dart';

class NoteProvider with ChangeNotifier {
  bool isLoading = true;
  List<Note> notes = [];

  NoteProvider() {
    fetchNotes();
  }

  // sort the notes according the time its added
  void sortNotes() {
    notes.sort((a, b) => b.dateadded!.compareTo(a.dateadded!));
  }

  List<Note> getSearchedNotes(String query) {
    return notes
        .where((element) =>
            element.title!.toLowerCase().contains(query.toLowerCase()) ||
            element.content!.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  void addNote(Note newNote) {
    notes.add(newNote);
    sortNotes();
    notifyListeners();
    // API SAVE
    ApiService.addNote(
        newNote); // it is called after notify listeners so that the UI is updated first and eventually the data is saved to the backend
  }

  void updateNote(Note note) {
    int index =
        notes.indexOf(notes.firstWhere((element) => element.id == note.id));
    notes[index] = note;
    sortNotes();
    notifyListeners();
    ApiService.addNote(note);
  }

  void deleteNote(Note note) {
    int index =
        notes.indexOf(notes.firstWhere((element) => element.id == note.id));
    notes.removeAt(index);
    sortNotes();
    notifyListeners();
    ApiService.deleteNode(note);
  }

  void fetchNotes() async {
    notes = await ApiService.fetchNotes("admin");
    sortNotes();
    isLoading = false;
    notifyListeners();
  }
}
