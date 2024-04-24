import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import '../db/notes_database.dart';
import '../model/note.dart';
import '../widget/common_buttons.dart';
import '../widget/note_form_widget.dart';
import 'select_photo_options_screen.dart';

class AddEditNotePage extends StatefulWidget {
  final Note? note;

  const AddEditNotePage({
    super.key,
    this.note,
  });

  @override
  State<AddEditNotePage> createState() => _AddEditNotePageState();
}

class _AddEditNotePageState extends State<AddEditNotePage> {
  final _formKey = GlobalKey<FormState>();
  late bool isImportant;
  late int number;
  late String title;
  late String description;
  late String image;
  Color backgroundColor = Colors.grey[850]!;
  File? _image;

  @override
  void initState() {
    super.initState();
    isImportant = widget.note?.isImportant ?? false;
    number = widget.note?.number ?? 0;
    title = widget.note?.title ?? '';
    description = widget.note?.description ?? '';
    image = widget.note?.image ?? 'https://picsum.photos/250?image=9';
  }

  Future _pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;
      File? img = File(image.path);
      img = await _cropImage(imageFile: img);
      setState(() {
        _image = img;
        Navigator.of(context).pop();
      });
    } on PlatformException catch (e) {
      print(e);
      if (!mounted) return;
      Navigator.of(context).pop();
    }
  }



  Future<File?> _cropImage({required File imageFile}) async {
    CroppedFile? croppedImage =
    await ImageCropper().cropImage(sourcePath: imageFile.path);
    if (croppedImage == null) return null;
    return File(croppedImage.path);
  }

  void _showSelectPhotoOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0),
        ),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.28,
        maxChildSize: 0.4,
        minChildSize: 0.28,
        expand: false,
        builder: (context, scrollController) {
          return SingleChildScrollView(
            controller: scrollController,
            child: SelectPhotoOptionsScreen(
              onTap: _pickImage,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context);
        },
        color: Colors.red[400],
      ),
      actions: [buildButton()],
      backgroundColor: Colors.grey[900],
    ),
    backgroundColor: backgroundColor,
    body: Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // const SizedBox(height: 30),
          // const Text(
          //   'Set a photo of yourself',
          //   style: TextStyle(
          //     color: Colors.black,
          //     fontSize: 24,
          //     fontWeight: FontWeight.bold,
          //   ),
          // ),
          // const SizedBox(height: 8),
          // const Text(
          //   'Photos make your profile more engaging',
          //   style: TextStyle(
          //     fontSize: 18,
          //     color: Colors.black87,
          //   ),
          // ),
          // const SizedBox(height: 8),
          // Center(
          //   child: Column(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: [
          //       GestureDetector(
          //         behavior: HitTestBehavior.translucent,
          //         onTap: () {
          //           _showSelectPhotoOptions(context);
          //         },
          //         child: Container(
          //           height: 100.0,
          //           width: 100.0,
          //           decoration: BoxDecoration(
          //             shape: BoxShape.circle,
          //             color: Colors.grey.shade200,
          //           ),
          //           child: Center(
          //             child: image == null
          //                 ? const Text(
          //               'No image selected',
          //               style: TextStyle(fontSize: 15),
          //             )
          //                 : CircleAvatar(
          //               backgroundImage: NetworkImage(image),
          //               radius: 100.0,
          //             ),
          //           ),
          //         ),
          //       ),
          //       const SizedBox(height: 30),
          //       CommonButtons(
          //         onTap: () => _showSelectPhotoOptions(context),
          //         backgroundColor: Colors.grey[900]!,
          //         textColor: Colors.white,
          //         textLabel: 'Add a Photo',
          //       ),
          //     ],
          //   ),
          // ),

          const SizedBox(height: 10),
          Form(
            key: _formKey,
            child: NoteFormWidget(
              isImportant: isImportant,
              number: number,
              title: title,
              description: description,
              image: image,
              onChangedImportant: (isImportant) =>
                  setState(() => this.isImportant = isImportant),
              onChangedNumber: (number) =>
                  setState(() => this.number = number),
              onChangedTitle: (title) =>
                  setState(() => this.title = title),
              onChangedDescription: (description) =>
                  setState(() => this.description = description),
              onChangedImage: (image) =>
                  setState(() => this.image = image),
            ),
          ),
          // Container(
          //   height: 300.0,
          //   width: 300.0,
          //   decoration: BoxDecoration(
          //     shape: BoxShape.rectangle,
          //     color: Colors.grey.shade200,
          //   ),
          //   child: Center(
          //     child: image == null
          //         ? const Text(
          //       'No image selected',
          //       style: TextStyle(fontSize: 15),
          //     )
          //         : CircleAvatar(
          //       backgroundImage: NetworkImage(image),
          //       radius: 300.0,
          //     ),
          //   ),
          // ),
          const SizedBox(height: 8),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  // onTap: () {
                  //   _showSelectPhotoOptions(context);
                  // },
                  child: Container(
                    height: 300.0,
                    width: 300.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Colors.grey.shade200,
                    ),
                    child: Center(
                      child: image == null
                          ? const Text(
                        'No image selected',
                        style: TextStyle(fontSize: 15),
                      )
                          : CircleAvatar(
                        backgroundImage: NetworkImage(image),
                        radius: 300.0,
                      ),
                      // Container(
                      //   // duration: Duration(milliseconds: 300),
                      //   decoration: BoxDecoration(
                      //     image: DecorationImage(
                      //       image: image,
                      //       fit: BoxFit.cover,
                      //     ),
                      //
                      //     // your own shape
                      //     shape: BoxShape.rectangle,
                      //   ),
                      // ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                // CommonButtons(
                //   onTap: () => _showSelectPhotoOptions(context),
                //   backgroundColor: Colors.grey[900]!,
                //   textColor: Colors.white,
                //   textLabel: 'Add a Photo',
                // ),
              ],
            ),
          ),
        ],
      ),
    ),
    floatingActionButton: FloatingActionButton(
      backgroundColor: Colors.grey[900],
      onPressed: _showColorPickerDialog,
      child: Icon(Icons.color_lens, color: Colors.red[400]),
    ),
  );

  Widget buildButton() {
    final isFormValid = title.isNotEmpty && description.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.grey[900],
          backgroundColor: isFormValid ? Colors.red[400] : Colors.red[200],
        ),
        onPressed: addOrUpdateNote,
        child: const Text('Save'),
      ),
    );
  }

  void _showColorPickerDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pick a color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: backgroundColor,
              onColorChanged: (color) {
                setState(() {
                  backgroundColor = color;
                });
              },
              colorPickerWidth: 300.0,
              pickerAreaHeightPercent: 0.7,
              enableAlpha: true,
              displayThumbColor: true,
              paletteType: PaletteType.hsv,
              pickerAreaBorderRadius: const BorderRadius.only(
                topLeft: Radius.circular(2.0),
                topRight: Radius.circular(2.0),
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void addOrUpdateNote() async {
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      final isUpdating = widget.note != null;

      if (isUpdating) {
        await updateNote();
      } else {
        await addNote();
      }
      if (!mounted) return;
      Navigator.of(context).pop();
    }
  }

  Future updateNote() async {
    final note = widget.note!.copy(
      isImportant: isImportant,
      number: number,
      title: title,
      description: description,
      image: image,
    );

    await NotesDatabase.instance.update(note);
  }

  Future addNote() async {
    final note = Note(
      title: title,
      isImportant: isImportant,
      number: number,
      description: description,
      image: image,
      createdTime: DateTime.now(),
    );

    await NotesDatabase.instance.create(note);
  }
}
