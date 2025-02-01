import 'dart:convert';

import 'package:al_quran_tafsir_and_audio/src/resources/api_response/some_api_response.dart';
import 'package:al_quran_tafsir_and_audio/src/resources/models/quran_surah_info_model.dart';
import 'package:al_quran_tafsir_and_audio/src/screens/home/controller/universal_controller.dart';
import 'package:al_quran_tafsir_and_audio/src/screens/home/search/model/search_res_model.dart';
import 'package:al_quran_tafsir_and_audio/src/screens/home/tabs/collection_tab/create_new_collection.dart/add_new_ayah.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';

class ShowSearchResult extends StatefulWidget {
  final String searchQuery;
  const ShowSearchResult({super.key, required this.searchQuery});

  @override
  State<ShowSearchResult> createState() => _ShowSearchResultState();
}

class _ShowSearchResultState extends State<ShowSearchResult> {
  SearchResModel? searchResModel;
  bool isLoading = true;
  @override
  void initState() {
    searchData(widget.searchQuery, true);
    super.initState();
  }

  void searchData(String q, bool newSearch) async {
    isLoading = true;
    String url =
        'https://api.quran.com/api/v4/search?q=$q&language=${Get.locale?.languageCode}';
    try {
      await get(Uri.parse(url)).then(
        (value) {
          isLoading = false;
          if (value.statusCode == 200) {
            Map data = jsonDecode(value.body);
            if (newSearch) {
              searchResModel = SearchResModel.fromMap(
                  Map<String, dynamic>.from(data['search']));
              setState(() {});
            } else {
              SearchResModel newS = SearchResModel.fromMap(
                  Map<String, dynamic>.from(data['search']));
              searchResModel ??= SearchResModel();
              searchResModel!.results ??= [];
              searchResModel!.results!.addAll(newS.results ?? []);
              searchResModel!.currentPage = searchResModel!.currentPage! + 1;
              setState(() {});
            }
          }
        },
      );
    } catch (e) {
      searchResModel = null;
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Result'),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return getSearchWidgetPopup();
                },
              );
            },
            icon: const Icon(
              FluentIcons.search_24_filled,
            ),
          ),
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : (searchResModel == null || searchResModel!.results!.isEmpty)
              ? const Center(
                  child: Text('No Data Found'),
                )
              : ListView.builder(
                  itemCount: searchResModel?.results?.length ?? 0,
                  itemBuilder: (context, index) {
                    Result result = searchResModel!.results![index];
                    int surahNumber =
                        int.parse(result.verseKey!.split(':').first);
                    int ayahNumber =
                        int.parse(result.verseKey!.split(':').last);
                    QuranSurahInfoModel surahInfoModel =
                        QuranSurahInfoModel.fromMap(
                      allChaptersInfo[surahNumber - 1],
                    );
                    return GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        Get.to(
                          () => AddNewAyahForCollection(
                            selectedSurahNumber: surahNumber - 1,
                            selectedAyahNumber: ayahNumber - 1,
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.all(7),
                        padding: const EdgeInsets.all(7),
                        decoration: BoxDecoration(
                          color: Colors.grey.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  '${index + 1}. ${surahInfoModel.nameSimple} - $ayahNumber',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const Spacer(),
                                const Icon(
                                  Icons.arrow_forward,
                                  size: 18,
                                  color: Colors.lightGreen,
                                ),
                              ],
                            ),
                            const Divider(height: 4),
                            Align(
                              alignment: Alignment.topRight,
                              child: GetX<UniversalController>(
                                builder: (controller) => Text(
                                  result.text ?? '',
                                  textDirection: TextDirection.rtl,
                                  style: TextStyle(
                                    fontSize: controller.fontSizeArabic.value,
                                  ),
                                ),
                              ),
                            ),
                            const Divider(height: 4),
                            const Text(
                              'Translation',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Divider(height: 4),
                            Column(
                              children: List.generate(
                                result.translations?.length ?? 0,
                                (index) {
                                  return GetX<UniversalController>(
                                    builder: (controller) => Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Book Name: ${result.translations?[index].name ?? ""}\nLanguage: ${result.translations?[index].languageName ?? ""}',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        HtmlWidget(
                                          result.translations?[index].text ??
                                              '',
                                          buildAsync: false,
                                          textStyle: TextStyle(
                                            fontSize: controller
                                                .fontSizeTranslation.value,
                                          ),
                                        ),
                                        if (index <
                                            ((result.translations?.length ??
                                                    0) -
                                                1))
                                          const Divider(height: 4),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }

  Dialog getSearchWidgetPopup() {
    TextEditingController controller = TextEditingController();
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(7),
      ),
      insetPadding: const EdgeInsets.all(10),
      child: SizedBox(
        width: double.infinity,
        // height: 200,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 10,
                right: 10,
                top: 20,
              ),
              child: SearchBar(
                autoFocus: true,
                controller: controller,
                shape: const WidgetStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(7),
                    ),
                    side: BorderSide(
                      color: Colors.grey,
                      width: 1,
                    ),
                  ),
                ),
                backgroundColor: WidgetStatePropertyAll(
                  Colors.grey.withValues(alpha: 0.1),
                ),
                elevation: const WidgetStatePropertyAll(0),
                leading: const Icon(
                  Icons.search_rounded,
                ),
                hintText: 'type to search...',
              ),
            ),
            const Gap(10),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    setState(() {
                      isLoading = true;
                    });
                    searchData(controller.text, true);
                  },
                  label: const Text('Search'),
                  icon: const Icon(Icons.search_rounded),
                ),
              ),
            ),
            const Gap(10),
          ],
        ),
      ),
    );
  }
}
