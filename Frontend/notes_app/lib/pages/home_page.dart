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
      // appBar: AppBar(
      //   title: const Text(
      //     "Notes App",
      //     style: TextStyle(
      //       color: Colors.orange,
      //     ),
      //   ),
      //   backgroundColor: Colors.grey[900],
      //   centerTitle: true,
      // ),
      backgroundColor: Colors.black,
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
                              color: Colors.white,
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
                              hintStyle: TextStyle(fontWeight: FontWeight.bold),
                              filled: true,
                              fillColor: Color(0xff5D5E7D),
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
                                        color: Color(0xff9094D3),
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                        border: Border.all(
                                          color: Color(0xff9094D3),
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
                                              color: Colors.white,
                                              fontWeight: FontWeight.w800,
                                              fontSize: 25.0,
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          Text(
                                            currentNote.content!,
                                            maxLines: 6,
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
                                        color: Colors.white,
                                      ),
                                      SizedBox(
                                        height: 20.0,
                                      ),
                                      Text(
                                        'No results for "$searchQuery"',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 24.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5.0,
                                      ),
                                      Text(
                                        'Check the spelling or try a new search',
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
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
        backgroundColor: Color(0xffFCFF61),
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
          Icons.add,
          color: Colors.black,
        ),
      ),
    );
  }
}
