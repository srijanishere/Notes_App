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
    int size = noteProvider.notes.length;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Notes($size)',
            style: TextStyle(
              color: Colors.black,
              fontSize: 30,
              // fontWeight: FontWeight.bold,
              fontFamily: 'SpaceMono',
            ),
          ),
        ),
        backgroundColor: Color(0xFFE6E7E9),
        centerTitle: false,
      ),
      backgroundColor: Color(0xFFE6E7E9),
      body: (noteProvider.isLoading == false)
          ? SafeArea(
              child: (noteProvider.notes.isNotEmpty)
                  ? ListView(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(20.0),
                          child: TextField(
                            cursorColor: Colors.black,
                            onChanged: (value) {
                              setState(() {
                                searchQuery = value;
                              });
                            },
                            style: TextStyle(
                              fontFamily: 'SpaceMono',
                              color: Colors.black,
                            ),
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xff5D5E7D),
                                ),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              suffixIcon: Icon(
                                Icons.search,
                                color: Color.fromARGB(255, 48, 50, 102),
                              ),
                              hintText: "Search",
                              hintStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: 'SpaceMono',
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              focusColor: Color(0xffc0d59e),
                              border: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  style: BorderStyle.solid,
                                  color: Colors.black,
                                ),
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
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                        border: Border.all(
                                          color: Colors.black,
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
                                              color: Colors.black,
                                              fontFamily: 'SpaceMono',
                                              fontWeight: FontWeight.w800,
                                              fontSize: 25.0,
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          Text(
                                            currentNote.content!,
                                            maxLines: 4,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black,
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
                                child: Center(
                                  child: Column(
                                    children: [
                                      Icon(
                                        Icons.search_rounded,
                                        size: 60,
                                        color: Colors.black,
                                      ),
                                      SizedBox(
                                        height: 20.0,
                                      ),
                                      Text(
                                        'No results for "$searchQuery"',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: 'SpaceMono',
                                          fontSize: 24.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5.0,
                                      ),
                                      Text(
                                        'Check the spelling or try a new search',
                                        style: TextStyle(
                                          fontFamily: 'SpaceMono',
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                      ],
                    )
                  : Center(
                      child: Text(
                        'No notes yet',
                        style: TextStyle(
                          fontFamily: 'SpaceMono',
                          color: Colors.white,
                        ),
                      ),
                    ),
            )
          : Center(
              child: LoadingAnimationWidget.stretchedDots(
                color: Colors.purple,
                size: 100,
              ),
            ),
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
          side: BorderSide(width: 3, color: Colors.black),
        ),
        backgroundColor: Colors.white,
        onPressed: () {
          Navigator.push(
            context,
            CupertinoPageRoute(
              fullscreenDialog: true,
              builder: (content) => const AddNewNote(isUpdate: false),
            ),
          );
        },
        child: Icon(
          Icons.edit_outlined,
          color: Colors.black,
        ),
      ),
    );
  }
}
