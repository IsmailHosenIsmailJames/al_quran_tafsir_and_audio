import 'dart:convert';
import 'dart:developer';

import 'package:al_quran_tafsir_and_audio/src/resources/models/quran_surah_info_model.dart';
import 'package:al_quran_tafsir_and_audio/src/screens/notes/models/notes_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../resources/api_response/some_api_response.dart';
import 'take_note_page.dart';

class AllNotes extends StatefulWidget {
  const AllNotes({super.key});

  @override
  State<AllNotes> createState() => _AllNotesState();
}

class _AllNotesState extends State<AllNotes> {
  final notesDB = Hive.box("notes_db");
  @override
  Widget build(BuildContext context) {
    log(notesDB.keys.toString());
    return ListView.builder(
      itemCount: notesDB.length,
      itemBuilder: (context, index) {
        final note = notesDB.getAt(index);
        NotesModel notesModel = NotesModel.fromJson(note!);
        QuranSurahInfoModel? quranSurahInfoModel =
            notesModel.surahNumber != null
                ? QuranSurahInfoModel.fromMap(
                    allChaptersInfo[notesModel.surahNumber! - 1],
                  )
                : null;

        QuillController controller = QuillController(
          document: Document.fromJson(
            jsonDecode(notesModel.noteDelta),
          ),
          selection: const TextSelection.collapsed(offset: 0),
          readOnly: true,
        );
        return Container(
          height: 200,
          padding: EdgeInsets.all(5),
          margin: EdgeInsets.all(5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(7),
            color: Colors.grey.withValues(
              alpha: 0.1,
            ),
          ),
          width: double.infinity,
          child: Column(
            children: [
              Expanded(
                child: Scrollbar(
                  child: QuillEditor.basic(
                    controller: controller,
                    config: QuillEditorConfig(
                      checkBoxReadOnly: true,
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  Text(
                      "Surah: ${quranSurahInfoModel?.nameSimple ?? ""}, Ayah: ${(notesModel.ayahNumber ?? 0) + 1} "),
                  Spacer(),
                  IconButton(
                    onPressed: () async {
                      await Get.to(
                        () => TakeNotePage(
                          previousData: notesModel,
                          surahNumber: notesModel.surahNumber,
                        ),
                      );
                      setState(() {});
                    },
                    icon: Icon(
                      Icons.edit,
                      color: Colors.green,
                    ),
                  ),
                  Gap(10),
                  IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          insetPadding: EdgeInsets.all(10),
                          title: Text("Are you sure?"),
                          content: Text("Once deleted, it can't be recovered"),
                          actions: [
                            TextButton(
                              onPressed: () {
                                notesDB.deleteAt(index);
                                Navigator.pop(context);
                              },
                              child: Text(
                                "Yes",
                                style: TextStyle(
                                  color: Colors.red,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text("No"),
                            ),
                          ],
                        ),
                      );
                    },
                    icon: Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }
}
