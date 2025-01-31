import 'dart:convert';

import 'package:al_quran_tafsir_and_audio/src/resources/models/quran_surah_info_model.dart';
import 'package:al_quran_tafsir_and_audio/src/screens/home/tabs/collection_tab/create_new_collection.dart/add_new_ayah.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:gap/gap.dart';
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

  List<String> ayahsListKey = [];

  @override
  void initState() {
    if (widget.ayahNumber != null && widget.surahNumber != null) {
      ayahsListKey.add('${widget.surahNumber}:${widget.ayahNumber! + 1}');
    }
    ayahsListKey.addAll(widget.previousData?.ayahsKey ?? []);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 5,
        title: const Text(
          'Take Note',
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
              int timeStamp = widget.previousData?.dateTimestamp ??
                  DateTime.now().millisecondsSinceEpoch;
              NotesModel notesModel = NotesModel(
                dateTimestamp: timeStamp,
                noteDelta: noteDelta,
                ayahsKey: ayahsListKey,
              );
              await Hive.box('notes_db')
                  .put(timeStamp.toString(), notesModel.toJson());
              Get.back();
            },
            icon: const Icon(
              Icons.done,
            ),
            label: Text(widget.previousData == null ? 'Save' : 'Update'),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: ListView(
            children: [
              Row(
                children: [
                  const Gap(8),
                  const Text(
                    'Ayahs',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    height: 30,
                    child: OutlinedButton.icon(
                      style: TextButton.styleFrom(
                          padding: const EdgeInsets.only(right: 10, left: 5)),
                      onPressed: () async {
                        final res = await Get.to(
                          () => const AddNewAyahForCollection(),
                        );
                        if (res != null && res is String) {
                          ayahsListKey.add(res);
                        }
                        setState(() {});
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('Add'),
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(7),
                ),
                child: ayahsListKey.isEmpty
                    ? const Text('No ayahs selected')
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: ayahsListKey.map(
                          (ayahKey) {
                            QuranSurahInfoModel surahInfoModel =
                                QuranSurahInfoModel.fromMap(allChaptersInfo[
                                    int.parse(ayahKey.split(':')[0]) - 1]);
                            return Row(
                              children: [
                                Text(
                                  "${surahInfoModel.nameSimple} - ${ayahKey.split(":")[1]}",
                                ),
                                const Spacer(),
                                SizedBox(
                                  height: 30,
                                  child: IconButton(
                                    onPressed: () {
                                      ayahsListKey.remove(ayahKey);
                                      setState(() {});
                                    },
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                      size: 19,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ).toList(),
                      ),
              ),
              const Gap(10),
              const Padding(
                padding: EdgeInsets.only(left: 8),
                child: Text(
                  'Notes',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
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
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey.withValues(alpha: 0.5),
                  ),
                  borderRadius: BorderRadius.circular(7),
                ),
                padding: const EdgeInsets.all(5),
                child: QuillEditor.basic(
                  controller: _controller,
                  config: const QuillEditorConfig(
                    minHeight: 200,
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
