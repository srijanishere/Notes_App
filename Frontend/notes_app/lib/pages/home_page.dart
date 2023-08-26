import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/pages/add_new_note.dart';
import 'package:notes_app/providers/note_provider.dart';
import 'package:provider/provider.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../models/note.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    NoteProvider noteProvider = Provider.of<NoteProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Notes App"),
        centerTitle: true,
      ),
      body: (noteProvider.isLoading == false)
          ? SafeArea(
              child: (noteProvider.notes.isNotEmpty)
                  ? ListView(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(20.0),
                          child: TextField(
                            onChanged: (value) {
                              setState(() {
                                searchQuery = value;
                              });
                            },
                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                icon: Icon(Icons.search),
                                onPressed: () {},
                              ),
                              hintText: "Search",
                              // filled: true,
                              // fillColor: Color(0xffc0d59e),
                              border: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(style: BorderStyle.solid),
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                          ),
                        ),
                        (noteProvider.getSearchedNotes(searchQuery).length > 0)
                            ? GridView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount:
                                      2, //each row can have two widgets
                                ),
                                itemCount: noteProvider
                                    .getSearchedNotes(searchQuery)
                                    .length,
                                itemBuilder: (context, index) {
                                  Note currentNote = noteProvider
                                      .getSearchedNotes(searchQuery)[index];
                                  return GestureDetector(
                                    onTap: () {
                                      // update
                                      Navigator.push(
                                        context,
                                        CupertinoPageRoute(
                                          builder: (context) => AddNewNote(
                                            isUpdate: true,
                                            note: currentNote,
                                          ),
                                        ),
                                      );
                                    },
                                    onLongPress: () {
                                      // delete
                                      noteProvider.deleteNote(currentNote);
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.all(10.0),
                                      padding: const EdgeInsets.all(10.0),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                        border: Border.all(
                                          color: Colors.grey,
                                          width: 3,
                                        ),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            currentNote.title!,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20.0,
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          Text(
                                            currentNote.content!,
                                            maxLines: 6,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 15.0,
                                              color: Colors.grey[700],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              )
                            : Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: const Center(
                                  child: Text("No such note found!"),
                                ),
                              ),
                      ],
                    )
                  : Center(
                      child: Text('No notes yet'),
                    ),
            )
          : Center(
              child: LoadingAnimationWidget.stretchedDots(
                color: Colors.purple,
                size: 100,
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            CupertinoPageRoute(
              fullscreenDialog: true,
              builder: (content) => const AddNewNote(isUpdate: false),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
