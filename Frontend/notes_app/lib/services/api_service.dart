import 'dart:convert';
import 'dart:developer';

import '../models/note.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static String _baseURL = "https://notes-app-wv79.onrender.com/notes";

  static Future<void> addNote(Note note) async {
    Uri requestUri = Uri.parse(_baseURL + "/add");
    var response = await http.post(requestUri, body: note.toMap());
    var decodedResponse = jsonDecode(response.body);
    log(decodedResponse.toString());
  }

  static Future<void> deleteNode(Note note) async {
    Uri requestUri = Uri.parse(_baseURL + "/delete");
    var response = await http.post(requestUri, body: note.toMap());
    var decodedResponse = jsonDecode(response.body);
    log(decodedResponse.toString());
  }

  static Future<List<Note>> fetchNotes(String userid) async {
    Uri requestUri = Uri.parse(_baseURL + "/list");
    var response = await http.post(requestUri, body: {"userid": userid});
    var decodedResponse = jsonDecode(response.body);
    List<Note> notes = [];
    for (var noteMap in decodedResponse) {
      Note newNote = Note.fromMap(noteMap);
      notes.add(newNote);
    }
    return notes;
  }
}
