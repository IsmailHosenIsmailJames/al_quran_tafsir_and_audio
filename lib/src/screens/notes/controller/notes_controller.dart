import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '../models/notes_model.dart';

class NotesController extends GetxController {
  RxList<NotesModel> notes = <NotesModel>[].obs;

  @override
  void onInit() {
    notes.value = [];
    final notesDB = Hive.box('notes_db');
    for (var key in notesDB.keys) {
      NotesModel notesModel = NotesModel.fromJson(notesDB.get(key));
      notes.add(notesModel);
    }
    super.onInit();
  }
}
