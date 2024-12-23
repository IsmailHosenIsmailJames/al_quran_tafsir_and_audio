import 'package:al_quran_tafsir_and_audio/src/core/audio/resources/recitation_info_model.dart';
import 'package:get/get.dart';

class InfoController extends GetxController {
  RxString appLanCode = ''.obs;
  RxString translationLanguage = "".obs;
  RxString bookIDTranslation = "-1".obs;
  RxInt bookNameIndex = (-1).obs;
  RxInt tafsirIndex = (-1).obs;
  RxString tafsirID = "-1".obs;
  RxString tafsirLanguage = "null".obs;
  RxInt tafsirBookIndex = (-1).obs;
  RxString tafsirBookID = "-1".obs;
  Rx<RecitationInfoModel> recitationIndex = Rx(RecitationInfoModel());
  RxString recitationName = "-1".obs;
  RxString tafsirBookName = "null".obs;
  RxString translationBookName = "null".obs;
}
