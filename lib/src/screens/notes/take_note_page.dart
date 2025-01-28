import 'dart:convert';

import 'package:al_quran_tafsir_and_audio/src/screens/surah_view/models/surah_view_info_model.dart';
import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:toastification/toastification.dart';

import '../../resources/api_response/some_api_response.dart';
import 'models/notes_model.dart';

class TakeNotePage extends StatefulWidget {
  final int? surahNumber;
  final int? ayahNumber;
  final NotesModel? previousData;
  const TakeNotePage({
    super.key,
    this.surahNumber,
    this.ayahNumber,
    this.previousData,
  });

  @override
  State<TakeNotePage> createState() => _TakeNotePageState();
}

class _TakeNotePageState extends State<TakeNotePage> {
  late final QuillController _controller = widget.previousData == null
      ? QuillController.basic()
      : QuillController(
          document: Document.fromJson(
            jsonDecode(widget.previousData!.noteDelta),
          ),
          selection: const TextSelection.collapsed(offset: 0),
        );
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 5,
        title: Text(
          widget.surahNumber != null
              ? "${allChaptersInfo[widget.surahNumber! - 1]["name_simple"]} ( ${(widget.ayahNumber ?? 0) + 1} )"
              : "",
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          ElevatedButton.icon(
            onPressed: () async {
              if (_controller.document.toPlainText().isEmpty) {
                toastification.show(
                  context: context,
                  title: const Text("Note can't be empty"),
                  type: ToastificationType.info,
                  autoCloseDuration: const Duration(seconds: 2),
                );
                return;
              }
              String noteDelta =
                  jsonEncode(_controller.document.toDelta().toJson());
              int timeStamp = DateTime.now().millisecondsSinceEpoch;
              NotesModel notesModel = NotesModel(
                dateTimestamp: widget.previousData?.dateTimestamp ?? timeStamp,
                noteDelta: noteDelta,
                surahNumber: widget.surahNumber,
                ayahNumber: widget.ayahNumber,
              );
              await Hive.box("notes_db").put(
                  widget.previousData == null
                      ? timeStamp.toString()
                      : widget.previousData!.dateTimestamp.toString(),
                  notesModel.toJson());
              Get.back();
            },
            icon: const Icon(
              Icons.done,
            ),
            label: Text(widget.previousData == null ? "Save" : "Update"),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    QuillToolbarHistoryButton(
                      isUndo: true,
                      controller: _controller,
                    ),
                    QuillToolbarHistoryButton(
                      isUndo: false,
                      controller: _controller,
                    ),
                    QuillToolbarToggleStyleButton(
                      options: const QuillToolbarToggleStyleButtonOptions(),
                      controller: _controller,
                      attribute: Attribute.bold,
                    ),
                    QuillToolbarToggleStyleButton(
                      options: const QuillToolbarToggleStyleButtonOptions(),
                      controller: _controller,
                      attribute: Attribute.italic,
                    ),
                    QuillToolbarToggleStyleButton(
                      controller: _controller,
                      attribute: Attribute.underline,
                    ),
                    QuillToolbarClearFormatButton(
                      controller: _controller,
                    ),
                    QuillToolbarColorButton(
                      controller: _controller,
                      isBackground: false,
                    ),
                    QuillToolbarColorButton(
                      controller: _controller,
                      isBackground: true,
                    ),
                    QuillToolbarSelectHeaderStyleDropdownButton(
                      controller: _controller,
                    ),
                    QuillToolbarSelectLineHeightStyleDropdownButton(
                      controller: _controller,
                    ),
                    QuillToolbarToggleCheckListButton(
                      controller: _controller,
                    ),
                    QuillToolbarToggleStyleButton(
                      controller: _controller,
                      attribute: Attribute.ol,
                    ),
                    QuillToolbarToggleStyleButton(
                      controller: _controller,
                      attribute: Attribute.ul,
                    ),
                    QuillToolbarToggleStyleButton(
                      controller: _controller,
                      attribute: Attribute.blockQuote,
                    ),
                    QuillToolbarIndentButton(
                      controller: _controller,
                      isIncrease: true,
                    ),
                    QuillToolbarIndentButton(
                      controller: _controller,
                      isIncrease: false,
                    ),
                    QuillToolbarLinkStyleButton(
                      controller: _controller,
                    ),
                    QuillToolbarSearchButton(
                      controller: _controller,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey.withValues(alpha: 0.5),
                    ),
                    borderRadius: BorderRadius.circular(7),
                  ),
                  padding: EdgeInsets.all(5),
                  child: QuillEditor.basic(
                    controller: _controller,
                    config: const QuillEditorConfig(),
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
