import 'package:al_quran_tafsir_and_audio/src/screens/home/tabs/collection_tab/controller/collection_model.dart';
import 'package:appwrite/appwrite.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

class CollectionController extends GetxController {
  RxList<CollectionInfoModel> collectionList = <CollectionInfoModel>[].obs;
  Rx<CollectionInfoModel> editingCollection =
      Rx<CollectionInfoModel>(CollectionInfoModel(
    id: ID.unique(),
    isPublicResources: false,
    name: '',
  ));

  @override
  void onInit() {
    collectionList.value = [];
    Hive.box('collections_db').keys.forEach((key) {
      CollectionInfoModel collectionInfoModel =
          CollectionInfoModel.fromJson(Hive.box('collections_db').get(key));
      collectionList.add(collectionInfoModel);
    });
    collectionList.value.sort(
      (a, b) => a.id.compareTo(b.id),
    );
    super.onInit();
  }
}
