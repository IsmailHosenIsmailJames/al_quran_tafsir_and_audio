import 'dart:convert';
import 'dart:developer';

import 'package:al_quran_tafsir_and_audio/src/functions/get_native_surah_name.dart';
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

import '../../../translations/map_of_translation.dart';

class ShowSearchResult extends StatefulWidget {
  final String searchQuery;
  final String lanCode;
  const ShowSearchResult(
      {super.key, required this.searchQuery, required this.lanCode});

  @override
  State<ShowSearchResult> createState() => _ShowSearchResultState();
}

class _ShowSearchResultState extends State<ShowSearchResult> {
  SearchResModel? searchResModel;
  late String lanCode = widget.lanCode;
  late String query = widget.searchQuery;
  bool isLoading = true;
  @override
  void initState() {
    searchData(true);
    super.initState();
  }

  void searchData(bool newSearch) async {
    setState(() {
      isLoading = true;
    });
    String url =
        'https://api.quran.com/api/v4/search?q=$query&language=${widget.lanCode}';
    try {
      final value = await get(Uri.parse(url));
      isLoading = false;
      if (value.statusCode == 200) {
        Map data = jsonDecode(value.body);
        if (newSearch) {
          searchResModel =
              SearchResModel.fromMap(Map<String, dynamic>.from(data['search']));
          setState(() {});
        } else {
          SearchResModel newS =
              SearchResModel.fromMap(Map<String, dynamic>.from(data['search']));
          searchResModel ??= SearchResModel();
          searchResModel!.results ??= [];
          searchResModel!.results!.addAll(newS.results ?? []);
          searchResModel!.currentPage = searchResModel!.currentPage! + 1;
          setState(() {});
        }
      }
    } catch (e) {
      log(e.toString());
      searchResModel = null;
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            showDialog(
              context: context,
              builder: (context) {
                return getSearchWidgetPopup();
              },
            );
          },
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.only(left: 10, top: 5, bottom: 5),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Text(
                query,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
        ),
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
      body: (isLoading && searchResModel == null)
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : (searchResModel == null || searchResModel!.results!.isEmpty)
              ? Center(
                  child: Text('No Search Result Found'.tr),
                )
              : Column(
                  children: [
                    if (isLoading)
                      const SafeArea(child: LinearProgressIndicator()),
                    Expanded(
                      child: NotificationListener<ScrollEndNotification>(
                        onNotification: (notification) {
                          if (notification.metrics.pixels ==
                              notification.metrics.maxScrollExtent) {
                            if ((searchResModel?.currentPage ?? 0) <
                                (searchResModel?.totalPages ?? 0)) {
                              searchData(false);
                              log('message');
                            }
                          }
                          return false;
                        },
                        child: ListView.builder(
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
                            return Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.all(0),
                                  backgroundColor:
                                      Colors.grey.withValues(alpha: 0.1),
                                  side: BorderSide(
                                    color: Colors.grey.withValues(alpha: 0.3),
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(7),
                                  ),
                                ),
                                onPressed: () async {
                                  await Get.to(
                                    () => AddNewAyahForCollection(
                                      selectedSurahNumber: surahNumber - 1,
                                      selectedAyahNumber: ayahNumber - 1,
                                    ),
                                  );
                                  setState(() {});
                                },
                                child: Container(
                                  margin: const EdgeInsets.all(5),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            '${index + 1}. ${getSurahNativeName(Get.locale?.languageCode ?? 'en', surahInfoModel.id - 1)} - $ayahNumber',
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
                                              fontSize: controller
                                                  .fontSizeArabic.value,
                                              color: Theme.of(context)
                                                          .brightness ==
                                                      Brightness.dark
                                                  ? Colors.white
                                                  : Colors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const Divider(height: 4),
                                      Text(
                                        'Translation'.tr,
                                        style: const TextStyle(
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
                                                    '${'Book Name'.tr}: ${result.translations?[index].name ?? ""}\n${'Language'.tr}: ${result.translations?[index].languageName?.capitalizeFirst ?? ""}',
                                                    style: const TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                  HtmlWidget(
                                                    result.translations?[index]
                                                            .text ??
                                                        '',
                                                    buildAsync: false,
                                                    textStyle: TextStyle(
                                                      fontSize: controller
                                                          .fontSizeTranslation
                                                          .value,
                                                      color: Theme.of(context)
                                                                  .brightness ==
                                                              Brightness.dark
                                                          ? Colors.white
                                                          : Colors.black,
                                                    ),
                                                  ),
                                                  if (index <
                                                      ((result.translations
                                                                  ?.length ??
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
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }

  Dialog getSearchWidgetPopup() {
    TextEditingController controller = TextEditingController(text: query);
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text('${'Search'.tr} ${'Language'.tr}'),
                  const Gap(10),
                  Expanded(
                    child: SizedBox(
                      height: 40,
                      child: DropdownButtonFormField(
                        padding: EdgeInsets.zero,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.only(left: 10),
                        ),
                        value: lanCode,
                        items: List.generate(
                          used20LanguageMap.length,
                          (index) {
                            return DropdownMenuItem(
                              value: used20LanguageMap[index]['Code']!,
                              onTap: () {
                                lanCode = used20LanguageMap[index]['Code']!;
                              },
                              child: Text(used20LanguageMap[index]['Native']!),
                            );
                          },
                        ),
                        onChanged: (value) {},
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    setState(() {
                      query = controller.text.trim();
                      isLoading = true;
                    });
                    searchData(true);
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
