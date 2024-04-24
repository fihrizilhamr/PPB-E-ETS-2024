import 'package:flutter/material.dart';

class NoteFormWidget extends StatelessWidget {
  final bool? isImportant;
  final int? number;
  final String? title;
  final String? description;
  final String? image;
  final ValueChanged<bool> onChangedImportant;
  final ValueChanged<int> onChangedNumber;
  final ValueChanged<String> onChangedTitle;
  final ValueChanged<String> onChangedDescription;
  final ValueChanged<String> onChangedImage;

  const NoteFormWidget({
    super.key,
    this.isImportant = false,
    this.number = 0,
    this.title = '',
    this.description = '',
    this.image = 'https://picsum.photos/250?image=9',
    required this.onChangedImportant,
    required this.onChangedNumber,
    required this.onChangedTitle,
    required this.onChangedDescription,
    required this.onChangedImage,
  });

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            // mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                  "Title",
                textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Colors.white70,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
              ),
              buildTitle(),
              const SizedBox(height: 8),
              const Text(
                "Description",
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Colors.white70,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              buildDescription(),
              const SizedBox(height: 8),
              const Text(
                "Image Url",
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Colors.white70,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              buildImage(),
              const SizedBox(height: 16),
            ],
          ),
        ),
      );

  Widget buildTitle() => TextFormField(
        maxLines: 1,
        initialValue: title,
        style: const TextStyle(
          color: Colors.white70,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Title',
          hintStyle: const TextStyle(color: Colors.white70),
          fillColor: Colors.grey[900]
        ),
        validator: (title) =>
            title != null && title.isEmpty ? 'The title cannot be empty' : null,
        onChanged: onChangedTitle,
      );

  Widget buildDescription() => TextFormField(
        maxLines: 5,
        initialValue: description,
        style: const TextStyle(color: Colors.white60, fontSize: 18),
        decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: 'Type something...',
          hintStyle: TextStyle(color: Colors.white60),
        ),
        validator: (title) => title != null && title.isEmpty
            ? 'The description cannot be empty'
            : null,
        onChanged: onChangedDescription,
      );

  Widget buildImage() => TextFormField(
    maxLines: 1,
    initialValue: image,
    style: const TextStyle(
      color: Colors.white70,
      fontWeight: FontWeight.bold,
      fontSize: 18,
    ),
    decoration: const InputDecoration(
      border: InputBorder.none,
      hintText: 'Image Url',
      hintStyle: TextStyle(color: Colors.white70),
    ),
    validator: (title) => title != null && title.isEmpty
        ? 'The image cannot be empty'
        : null,
    onChanged: onChangedImage,
  );
}

