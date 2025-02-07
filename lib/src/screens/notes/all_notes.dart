import 'dart:convert';

import 'package:al_quran_tafsir_and_audio/src/core/show_twoested_message.dart';
import 'package:al_quran_tafsir_and_audio/src/resources/models/quran_surah_info_model.dart';
import 'package:al_quran_tafsir_and_audio/src/screens/notes/controller/notes_controller.dart';
import 'package:al_quran_tafsir_and_audio/src/screens/notes/models/notes_model.dart';
import 'package:al_quran_tafsir_and_audio/src/screens/notes/take_note_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:toastification/toastification.dart';

import '../../resources/api_response/some_api_response.dart';

class AllNotes extends StatefulWidget {
  const AllNotes({super.key});

  @override
  State<AllNotes> createState() => _AllNotesState();
}

class _AllNotesState extends State<AllNotes> {
  final NotesController notesController = Get.put(NotesController());
  final notesDB = Hive.box('notes_db');

  @override
  void initState() {
    notesController.onInit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (notesController.notes.isEmpty) {
      return Column(
        children: [
          const Gap(10),
          getAddNewNotesButton(),
          Gap(MediaQuery.of(context).size.height * 0.3),
          const Center(child: Text('No notes found')),
        ],
      );
    }
    return Column(
      children: [
        const Gap(10),
        getAddNewNotesButton(),
        Expanded(
          child: ListView.builder(
            itemCount: notesController.notes.length,
            itemBuilder: (context, index) {
              NotesModel notesModel = notesController.notes[index];

              QuillController controller = QuillController(
                document: Document.fromJson(
                  jsonDecode(notesModel.noteDelta),
                ),
                selection: const TextSelection.collapsed(offset: 0),
                readOnly: true,
              );
              return Container(
                height: 250 + notesModel.ayahsKey.length * 20,
                padding: const EdgeInsets.all(5),
                margin: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7),
                  color: Colors.grey.withValues(
                    alpha: 0.1,
                  ),
                ),
                width: double.infinity,
                child: getNotesWidget(notesModel, controller, context, index),
              );
            },
          ),
        ),
      ],
    );
  }

  Column getNotesWidget(NotesModel notesModel, QuillController controller,
      BuildContext context, int index) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Ayahs:',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const Gap(8),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(
            notesModel.ayahsKey.length,
            (index) {
              String ayahKey = notesModel.ayahsKey[index];
              QuranSurahInfoModel? quranSurahInfoModel =
                  QuranSurahInfoModel.fromMap(
                      allChaptersInfo[int.parse(ayahKey.split(':')[0])]);
              return Text(
                "${quranSurahInfoModel.nameSimple}, Ayah: ${int.parse(notesModel.ayahsKey[index].split(":")[1]) + 1} ",
              );
            },
          ),
        ),
        const Divider(),
        const Text(
          'Note:',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const Gap(8),
        Expanded(
          child: Scrollbar(
            child: QuillEditor.basic(
              controller: controller,
              config: const QuillEditorConfig(
                checkBoxReadOnly: true,
              ),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              onPressed: () async {
                await Get.to(
                  () => TakeNotePage(
                    previousData: notesModel,
                  ),
                );
                notesController.onInit();
                setState(() {});
              },
              icon: const Icon(
                Icons.edit,
                color: Colors.green,
              ),
            ),
            IconButton(
              onPressed: () => showDialog(
                context: context,
                builder: (context) => getDeleteAlertPopup(index, context),
              ),
              icon: const Icon(
                Icons.delete,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ],
    );
  }

  AlertDialog getDeleteAlertPopup(int index, BuildContext context) {
    return AlertDialog(
      insetPadding: const EdgeInsets.all(10),
      title: const Text('Are you sure?'),
      content: const Text("Once deleted, it can't be recovered"),
      actions: [
        TextButton(
          onPressed: () {
            notesDB.deleteAt(index);
            Navigator.pop(context);
            notesController.onInit();

            setState(() {});
            showTwoestedMessage(
              'Deleted successfully',
              ToastificationType.success,
            );
          },
          child: const Text(
            'Yes',
            style: TextStyle(
              color: Colors.red,
            ),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('No'),
        ),
      ],
    );
  }

  Widget getAddNewNotesButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () async {
          await Get.to(
            () => const TakeNotePage(),
          );
          notesController.onInit();
          setState(() {});
        },
        icon: const Icon(Icons.add),
        label: const Text('Add New Note'),
      ),
    );
  }
}
