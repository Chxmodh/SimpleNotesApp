import 'package:flutter/material.dart';
import 'package:my_notes/model/notes_model.dart';
import 'package:my_notes/services/database_helper.dart';
import 'package:my_notes/screens/homepageNote.dart';

class AddEditNoteScreen extends StatefulWidget {
  final Note? note;
  const AddEditNoteScreen({super.key, this.note});

  @override
  State<AddEditNoteScreen> createState() => _AddEditNoteScreenState();
}

class _AddEditNoteScreenState extends State<AddEditNoteScreen> {
  final _formkey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  Color _selectedColor = Colors.amber; // Default color
  final List<Color> _colors = [
    Color(0xff002c2b),
    Color(0xffff3d00),
    Color(0xffffbc11),
    Color(0xff0a837f),
    Color(0xff076461),
    Color(0xff2f003f),
    Color(0xffbe0001),
    Color(0xffff8006),
    Color(0xff77477e),
    Color(0xff092b5a)
  ];

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      _titleController.text = widget.note!.title;
      _contentController.text = widget.note!.content;
      _selectedColor = Color(int.parse(widget.note!.color));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1C), // Dark background color
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        backgroundColor: const Color(0xFF1C1C1C), // Same background as body
        title: Text(widget.note == null ? 'Add Note' : "Edit Note",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
      ),

      body: SingleChildScrollView(
        child: Form(
          key: _formkey,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextFormField(
                  controller: _titleController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Title",
                    hintStyle: const TextStyle(color: Colors.white54),
                    filled: true,
                    fillColor: const Color(0xFF333333), // Field background color
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter a title";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _contentController,
                  style: const TextStyle(color: Colors.white),
                  maxLines: 7,
                  decoration: InputDecoration(
                    hintText: "Content",
                    hintStyle: const TextStyle(color: Colors.white54),
                    filled: true,
                    fillColor: const Color(0xFF333333), // Field background color
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter content";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _colors.map((color) {
                      return GestureDetector(
                        onTap: () => setState(() => _selectedColor = color),
                        child: Container(
                          height: 40,
                          width: 40,
                          margin: const EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(8), // Rounded rectangle
                            border: Border.all(
                              color: _selectedColor == color
                                  ? Colors.white
                                  : Colors.transparent,
                              width: 3,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Swipe',style: TextStyle(
                        color: Colors.white,
                        fontStyle: FontStyle.italic
                    ),
                    ),
                    SizedBox(width: 13),
                    Icon(Icons.swipe,color: Colors.white,size: 15),
                  ],
                ),
                const SizedBox(height: 30),
                ElevatedButton.icon(
                  onPressed: () async {
                    if (_formkey.currentState!.validate()) { // Validation check
                      await _saveNote();
                      _showSuccessDialog(context, isNewNote: widget.note == null); // Pass if it's a new note or not
                    }
                  },

                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white, // Background color
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  icon: const Icon(Icons.save, size: 23,color: Colors.black,),  // The icon to display
                  label: const Text("Save Note",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _saveNote() async {
    if (_formkey.currentState!.validate()) {
      final note = Note(
        id: widget.note?.id,
        title: _titleController.text,
        content: _contentController.text,
        color: _selectedColor.value.toString(),
        dateTime: DateTime.now().toString(),
      );

      if (widget.note == null) {
        await _databaseHelper.insertNote(note);
      } else {
        await _databaseHelper.updateNote(note);
      }
    }
  }
}

void _showSuccessDialog(BuildContext context, {required bool isNewNote}) {
  showDialog(
    context: context,
    builder: (context) => SimpleDialog(
      title: Text(
        isNewNote ? 'New note added!' : 'Note updated successfully!',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),
      ),
      contentPadding: const EdgeInsets.all(20.0),
      children: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          },
          child: const Text(
            'OK',
            style: TextStyle(
                color: Colors.redAccent,
                fontWeight: FontWeight.w600
            ),
          ),
        ),
      ],
    ),
  );
}
