import 'package:al_quran_tafsir_and_audio/src/core/audio/controller/audio_controller.dart';
import 'package:al_quran_tafsir_and_audio/src/core/audio/full_screen_mode%20copy/full_screen_mode.dart';
import 'package:al_quran_tafsir_and_audio/src/core/audio/play_quran_audio.dart';
import 'package:al_quran_tafsir_and_audio/src/resources/api_response/some_api_response.dart';
import 'package:al_quran_tafsir_and_audio/src/screens/home/controller/universal_controller.dart';
import 'package:al_quran_tafsir_and_audio/src/screens/surah_view/common/tajweed_scripts_composer.dart';
import 'package:al_quran_tafsir_and_audio/src/theme/theme_controller.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:line_icons/line_icons.dart';

class WidgetAudioController extends StatefulWidget {
  final bool showSurahNumber;
  final bool showQuranAyahMode;
  final int surahNumber;
  const WidgetAudioController({
    super.key,
    required this.showSurahNumber,
    required this.showQuranAyahMode,
    required this.surahNumber,
  });

  @override
  State<WidgetAudioController> createState() => _WidgetAudioControllerState();
}

class _WidgetAudioControllerState extends State<WidgetAudioController>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> animation;

  final UniversalController universalController = Get.find();

  @override
  void initState() {
    animationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    animation =
        Tween<double>(begin: 0.0, end: 1.0).animate(animationController);
    animationController.forward();
    super.initState();
  }

  AudioController audioController = ManageQuranAudio.audioController;
  final themeController = Get.put(AppThemeData());

  final userDB = Hive.box('user_db');
  final quranDB = Hive.box('quran_db');

  ScrollController scrollController = ScrollController();

  @override
  void dispose() {
    animationController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: AnimatedBuilder(
        animation: animationController,
        builder: (context, value) {
          return Obx(
            () {
              bool isDark = (themeController.themeModeName.value == 'dark' ||
                  (themeController.themeModeName.value == 'system' &&
                      MediaQuery.of(context).platformBrightness ==
                          Brightness.dark));
              Color colorToApply = isDark ? Colors.white : Colors.grey.shade900;
              int latestSurahNumber = audioController.currentSurahNumber.value;

              return Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (audioController.isSurahAyahMode.value)
                    Expanded(
                      child: getSurahView(
                        isDark,
                        latestSurahNumber,
                      ),
                    ),
                  getControllers(context, isDark, colorToApply),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget getSurahView(bool isDark, int latestSurahNumber) {
    int ayahStart = 0;
    for (int i = 0; i < latestSurahNumber; i++) {
      ayahStart += ayahCount[i];
    }
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.only(
            left: 5,
            right: 5,
            top: audioController.isFullScreenMode.value == false ? 25 : 5,
          ),
          decoration: BoxDecoration(
            color:
                isDark ? const Color.fromARGB(255, 29, 29, 29) : Colors.white,
            borderRadius: BorderRadius.circular(7),
            border: Border.all(
                color: Colors.grey.withValues(alpha: 0.5), width: 0.7),
          ),
          child: Scrollbar(
            controller: scrollController,
            thickness: 5,
            thumbVisibility: true,
            radius: const Radius.circular(7),
            interactive: true,
            child: getWidgetOfQuranWithTajweed(latestSurahNumber, ayahStart),
          ),
        ),
        if (!audioController.isFullScreenMode.value)
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 10),
              child: SizedBox(
                height: 25,
                width: 25,
                child: IconButton(
                  style: IconButton.styleFrom(
                      padding: EdgeInsets.zero,
                      backgroundColor:
                          isDark ? Colors.grey.shade900 : Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                        side:
                            BorderSide(color: Colors.grey.shade400, width: 0.7),
                      )),
                  onPressed: () {
                    audioController.isSurahAyahMode.value =
                        !audioController.isSurahAyahMode.value;
                  },
                  icon: const Icon(
                    Icons.close,
                    size: 15,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  ListView getWidgetOfQuranWithTajweed(int latestSurahNumber, ayahStart) {
    return ListView.builder(
        controller: scrollController,
        padding: const EdgeInsets.all(10),
        itemCount: (ayahCount[latestSurahNumber] / 10).ceil(),
        itemBuilder: (context, index) {
          int currentAyahCount = ayahCount[latestSurahNumber];
          int start = index * 10 + 1;
          int end = (index + 1) * 10;
          if (end > currentAyahCount) {
            end = currentAyahCount;
          }

          List<InlineSpan> listOfAyahsSpanText = [];

          for (int currentAyahNumber = start;
              currentAyahNumber <= end;
              currentAyahNumber++) {
            listOfAyahsSpanText.addAll(
              getTajweedTexSpan(
                quranDB.get(
                  'uthmani_tajweed/${ayahStart + currentAyahNumber}',
                  defaultValue: '',
                ),
              ),
            );
          }

          return Text.rich(
            TextSpan(children: listOfAyahsSpanText),
            style: TextStyle(
              fontSize: universalController.fontSizeArabic.value,
            ),
            textAlign: TextAlign.justify,
            textDirection: TextDirection.rtl,
          );
        });
  }

  Container getControllers(
      BuildContext context, bool isDark, Color colorToApply) {
    return Container(
      height: 115,
      width: animation.value * MediaQuery.of(context).size.width * 1,
      margin: EdgeInsets.only(
          left: 5,
          top: 10,
          right: 5,
          bottom: widget.showQuranAyahMode ? 10 : 70),
      padding: const EdgeInsets.only(left: 5, right: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(7),
        color: isDark ? Colors.grey.shade900 : Colors.white,
        border: Border.all(
            color: Colors.grey.shade400.withValues(alpha: 0.5), width: 0.7),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          ProgressBar(
            progress: audioController.progress.value,
            buffered: audioController.bufferPosition.value,
            total: audioController.totalDuration.value,
            progressBarColor: Colors.green,
            baseBarColor: colorToApply.withValues(alpha: 0.2),
            bufferedBarColor: Colors.green.shade200,
            thumbColor: const Color.fromARGB(255, 0, 119, 8),
            barHeight: 6.0,
            thumbRadius: 10.0,
            timeLabelLocation: TimeLabelLocation.sides,
            onSeek: (duration) {
              ManageQuranAudio.audioPlayer.seek(duration);
            },
          ),
          const Gap(5),
          Row(
            children: [
              SizedBox(
                width: 25,
                height: 25,
                child: FittedBox(
                  child: Center(
                    child: Text(
                      (audioController.currentPlayingAyah.value + 1).toString(),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: SizedBox(
                  height: 30,
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: Slider(
                    value: audioController.currentPlayingAyah.value.toDouble(),
                    onChanged: (value) {
                      ManageQuranAudio.audioPlayer.seek(
                          const Duration(seconds: 0),
                          index: value.toInt());
                    },
                    max: audioController.totalAyah.value.toDouble() - 1,
                    min: 0,
                    activeColor: Colors.green,
                    thumbColor: const Color.fromARGB(255, 0, 119, 8),
                    divisions: audioController.totalAyah.value - 1,
                  ),
                ),
              ),
              SizedBox(
                width: 25,
                height: 25,
                child: FittedBox(
                  child: Center(
                    child: Text(
                      audioController.totalAyah.value.toString(),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const Gap(5),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (widget.showQuranAyahMode)
                  SizedBox(
                    width: 40,
                    height: 40,
                    child: IconButton(
                      style: IconButton.styleFrom(
                        backgroundColor: audioController.isSurahAyahMode.value
                            ? Colors.green.withValues(
                                alpha: 0.2,
                              )
                            : null,
                        padding: EdgeInsets.zero,
                      ),
                      onPressed: () {
                        audioController.isSurahAyahMode.value =
                            !audioController.isSurahAyahMode.value;
                      },
                      icon: Icon(
                        LineIcons.quran,
                        color: audioController.isSurahAyahMode.value
                            ? Colors.green
                            : colorToApply,
                      ),
                    ),
                  ),
                if (widget.showSurahNumber)
                  CircleAvatar(
                    radius: 15,
                    child: Text(
                      audioController.currentPlayingAyah.value.toString(),
                      style: TextStyle(color: colorToApply),
                    ),
                  ),
                SizedBox(
                  width: 40,
                  height: 40,
                  child: IconButton(
                    style: IconButton.styleFrom(
                      padding: EdgeInsets.zero,
                    ),
                    onPressed: () {
                      int toSeek =
                          audioController.progress.value.inSeconds - 10;
                      if (toSeek < 0) {
                        toSeek = 0;
                      }
                      ManageQuranAudio.audioPlayer
                          .seek(Duration(seconds: toSeek));
                    },
                    icon: Icon(
                      FluentIcons.skip_back_10_24_regular,
                      color: colorToApply,
                    ),
                  ),
                ),
                SizedBox(
                  width: 40,
                  height: 40,
                  child: IconButton(
                    style: IconButton.styleFrom(
                      padding: EdgeInsets.zero,
                    ),
                    onPressed: audioController.currentPlayingAyah.value <= 0
                        ? null
                        : () {
                            ManageQuranAudio.audioPlayer.seekToPrevious();
                          },
                    icon: Icon(
                      Icons.skip_previous_rounded,
                      color: audioController.currentPlayingAyah.value <= 0
                          ? Colors.grey
                          : colorToApply,
                    ),
                  ),
                ),
                SizedBox(
                  width: 40,
                  height: 40,
                  child: IconButton(
                    style: IconButton.styleFrom(
                      padding: EdgeInsets.zero,
                    ),
                    onPressed: () async {
                      if (audioController.isLoading.value) {
                        return;
                      }
                      if (audioController.isPlaying.value) {
                        await ManageQuranAudio.audioPlayer.pause();
                      } else {
                        await ManageQuranAudio.audioPlayer.play();
                      }
                    },
                    icon: audioController.isLoading.value
                        ? SizedBox(
                            height: 40,
                            width: 40,
                            child: CircularProgressIndicator(
                              color: colorToApply,
                              strokeWidth: 3,
                            ),
                          )
                        : Icon(
                            audioController.isPlaying.value
                                ? Icons.pause_rounded
                                : Icons.play_arrow_rounded,
                            color: colorToApply,
                          ),
                  ),
                ),
                SizedBox(
                  width: 40,
                  height: 40,
                  child: IconButton(
                    style: IconButton.styleFrom(
                      padding: EdgeInsets.zero,
                    ),
                    onPressed: audioController.currentPlayingAyah.value >= 113
                        ? null
                        : () {
                            ManageQuranAudio.audioPlayer.seekToNext();
                          },
                    icon: Icon(
                      Icons.skip_next_rounded,
                      color: audioController.currentPlayingAyah.value >= 113
                          ? Colors.grey
                          : colorToApply,
                    ),
                  ),
                ),
                SizedBox(
                  width: 40,
                  height: 40,
                  child: IconButton(
                    style: IconButton.styleFrom(
                      padding: EdgeInsets.zero,
                    ),
                    onPressed: () {
                      int toSeek =
                          audioController.progress.value.inSeconds + 10;
                      if (toSeek >
                          audioController.totalDuration.value.inSeconds) {
                        toSeek = audioController.totalDuration.value.inSeconds;
                      }
                      ManageQuranAudio.audioPlayer
                          .seek(Duration(seconds: toSeek));
                    },
                    icon: Icon(
                      FluentIcons.skip_forward_10_24_regular,
                      color: colorToApply,
                    ),
                  ),
                ),
                if (widget.showQuranAyahMode)
                  SizedBox(
                    width: 40,
                    height: 40,
                    child: IconButton(
                      style: IconButton.styleFrom(
                        padding: EdgeInsets.zero,
                      ),
                      onPressed: () {
                        if (audioController.isFullScreenMode.value) {
                          Get.back();
                        } else {
                          Get.to(
                            () => const FullScreenAudioMode(),
                          );
                        }
                      },
                      icon: Icon(
                        audioController.isFullScreenMode.value
                            ? Icons.fullscreen_exit_rounded
                            : Icons.fullscreen_rounded,
                      ),
                    ),
                  ),
                SizedBox(
                  width: 40,
                  height: 40,
                  child: IconButton(
                    style: IconButton.styleFrom(
                      padding: EdgeInsets.zero,
                    ),
                    onPressed: () async {
                      await ManageQuranAudio.audioPlayer.stop();
                      await Future.delayed(const Duration(milliseconds: 200));
                      audioController.isReadyToControl.value = false;
                    },
                    icon: const Icon(Icons.close_rounded),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
