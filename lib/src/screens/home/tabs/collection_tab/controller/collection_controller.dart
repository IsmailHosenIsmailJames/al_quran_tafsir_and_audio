import 'package:al_quran_tafsir_and_audio/src/screens/home/tabs/collection_tab/controller/collection_model.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

class CollectionController extends GetxController {
  List<CollectionInfoModel> collectionList = [];

  @override
  void onInit() {
    Hive.box("collections_db").keys.forEach((key) {
      CollectionInfoModel collectionInfoModel =
          CollectionInfoModel.fromJson(Hive.box("collections_db").get(key));
      collectionList.add(collectionInfoModel);
    });
    super.onInit();
  }
}