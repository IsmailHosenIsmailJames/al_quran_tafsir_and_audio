import 'dart:developer';

import 'package:al_quran_tafsir_and_audio/src/screens/surah_view/models/surah_view_info_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:gap/gap.dart';

class TakeNotePage extends StatefulWidget {
  final SurahViewInfoModel surahViewInfoModel;
  final int ayahNumber;
  const TakeNotePage({
    super.key,
    required this.surahViewInfoModel,
    required this.ayahNumber,
  });

  @override
  State<TakeNotePage> createState() => _TakeNotePageState();
}

class _TakeNotePageState extends State<TakeNotePage> {
  final QuillController _controller = QuillController.basic();
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
          "Note for ${widget.surahViewInfoModel.surahNameSimple} ( ${widget.ayahNumber + 1} )",
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(
              Icons.done,
            ),
            label: Text("Save"),
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
