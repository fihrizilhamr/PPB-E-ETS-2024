import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../db/notes_database.dart';
import '../model/note.dart';
import '../page/edit_note_page.dart';
import '../page/note_detail_page.dart';
import '../widget/note_card_widget.dart';


class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  late List<Note> notes;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    refreshNotes();
  }

  @override
  void dispose() {
    NotesDatabase.instance.close();

    super.dispose();
  }




  Future refreshNotes() async {
    setState(() => isLoading = true);

    notes = await NotesDatabase.instance.readAllNotes();

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey[900],
          title: Text(
            'ETS',
            style: TextStyle(
                fontSize: 24,
              color: Colors.red[400],
            ),
          ),
          actions: const [Icon(Icons.search), SizedBox(width: 12)],
          centerTitle: true,
        ),
        body: Center(
          child: isLoading
              ? const CircularProgressIndicator()
              : notes.isEmpty
                  ? Text(
                      'No Notes',
                      style: TextStyle(fontSize: 24, color: Colors.red[400]),
                    )
                  : buildNotes(),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.grey[900],
          child: Icon(Icons.add,color: Colors.red[400]),
          onPressed: () async {
            await Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const AddEditNotePage()),
            );

            refreshNotes();
          },
        ),
      );
  Widget buildNotes() => StaggeredGrid.count(
    crossAxisCount: MediaQuery.of(context).size.width > 600 ? 4 : 2,
    mainAxisSpacing: 2,
    crossAxisSpacing: 2,
    children: List.generate(
      notes.length,
          (index) {
        final note = notes[index];

        return StaggeredGridTile.count(
          crossAxisCellCount: 1,
          mainAxisCellCount: 1,
          child: GestureDetector(
            onTap: () async {
              await Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => NoteDetailPage(noteId: note.id!),
              ));

              refreshNotes();
            },
            child: NoteCardWidget(note: note, index: index),
          ),
        );
      },
    ),
  );


}
