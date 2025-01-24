import 'dart:convert';

import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '../../theme/theme_controller.dart';
import '../auth/account_info/account_info.dart';
import '../auth/login/login.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with TickerProviderStateMixin {
  List<int> expandedPosition = [];
  List<AnimationController> controller = [];
  List<Animation<double>> sizeAnimation = [];

  bool bookmarkDone = false;
  bool favoriteDone = false;
  bool notesDone = false;

  @override
  void initState() {
    for (int i = 0; i < 3; i++) {
      final tem = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 350),
      );
      controller.add(tem);
      sizeAnimation.add(CurvedAnimation(parent: tem, curve: Curves.easeInOut));
      expandedPosition.add(-1);
    }

    final infoBox = Hive.box("user_db");
    favoriteDone = infoBox.get("favoriteUploaded", defaultValue: false);
    bookmarkDone = infoBox.get("bookmarkUploaded", defaultValue: false);
    final notes = Hive.box("notes");
    for (String key in notes.keys) {
      if (key.endsWith("title")) {
        String ayahKey = key.substring(0, 6);
        notesDone = notes.get(
          "${ayahKey}upload",
          defaultValue: false,
        );
        setState(() {
          notesDone;
        });
        if (notesDone == false) {
          break;
        }
      }
    }
    super.initState();
  }

  Future<void> uploadNotes(String keyOfAyah, titleText, notesText) async {
    Client client = Client()
        .setEndpoint("https://cloud.appwrite.io/v1")
        .setProject("albayanquran")
        .setSelfSigned(status: true);

    Databases databases = Databases(client);

    try {
      final account = Account(client);
      final user = await account.get();

      try {
        final document = await databases.getDocument(
            databaseId: "65bf585cdf62317b4d91",
            collectionId: "65bfa12aa542dc981ea8",
            documentId: user.$id);
        List listOfKey = jsonDecode(document.data['allnotes']);
        if (!listOfKey.contains(keyOfAyah)) {
          listOfKey.add(keyOfAyah);
        }

        await databases.updateDocument(
            databaseId: "65bf585cdf62317b4d91",
            collectionId: "65bfa12aa542dc981ea8",
            documentId: user.$id,
            data: {"allnotes": jsonEncode(listOfKey)});
      } catch (e) {
        await databases.createDocument(
            databaseId: "65bf585cdf62317b4d91",
            collectionId: "65bfa12aa542dc981ea8",
            documentId: user.$id,
            data: {
              "allnotes": jsonEncode([keyOfAyah])
            });
      }

      try {
        await databases.updateDocument(
          databaseId: "65bf585cdf62317b4d91",
          collectionId: "65d1ca40a427099b17f1",
          documentId: "${user.$id}$keyOfAyah",
          data: <String, String>{
            "title": titleText,
            "note": notesText,
          },
        );
      } catch (e) {
        await databases.createDocument(
          databaseId: "65bf585cdf62317b4d91",
          collectionId: "65d1ca40a427099b17f1",
          documentId: "${user.$id}$keyOfAyah",
          data: <String, String>{
            "title": titleText,
            "note": notesText,
          },
        );
      }
      String boxKeyForNoteUpload = "${keyOfAyah}upload";
      final box = Hive.box("notes");

      box.put(boxKeyForNoteUpload, true);
      setState(() {
        notesDone = true;
      });
    } catch (e) {
      showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("An Error Occurred"),
          content: Text(e.toString()),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("OK"),
            ),
          ],
        ),
      );
    }
  }

  void uploadAll() async {
    if (notesDone != true) {
      final notesBox = Hive.box("notes");
      for (String key in notesBox.keys) {
        if (key.endsWith("title") || key.endsWith("note")) {
          String ayahKey = key.substring(0, 6);
          String n = notesBox.get("${ayahKey}note", defaultValue: "");
          String t = notesBox.get("${ayahKey}title", defaultValue: "");
          if (!(notesBox.get("${ayahKey}upload", defaultValue: false))) {
            await uploadNotes(ayahKey, t, n);
          } else {
            debugPrint("object");
          }
          debugPrint("");
        }
      }
    }
    final infbox = Hive.box("user_db");
    Client client = Client()
        .setEndpoint("https://cloud.appwrite.io/v1")
        .setProject("albayanquran")
        .setSelfSigned(status: true);
    final account = Account(client);
    final user = await account.get();
    Databases databases = Databases(client);

    if (favoriteDone != true) {
      try {
        await databases.updateDocument(
          databaseId: "65bf585cdf62317b4d91",
          collectionId: "65bfa12aa542dc981ea8",
          documentId: user.$id,
          data: {
            "favorite": jsonEncode(
              infbox.get("favorite", defaultValue: []),
            ),
          },
        );
        infbox.put("favoriteUploaded", true);
        setState(() {
          favoriteDone = true;
        });
      } catch (e) {
        debugPrint(e.toString());
      }
    }
    if (bookmarkDone != true) {
      await databases.updateDocument(
        databaseId: "65bf585cdf62317b4d91",
        collectionId: "65bfa12aa542dc981ea8",
        documentId: user.$id,
        data: {
          "bookmark": jsonEncode(
            infbox.get("bookmark", defaultValue: []),
          ),
        },
      );
      infbox.put("bookmarkUploaded", true);
      setState(() {
        bookmarkDone = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(5),
      children: [
        !isLoggedIn
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextButton.icon(
                    onPressed: () {
                      Get.to(() => const LogIn());
                    },
                    label: Text(
                      "LogIn".tr,
                      style: const TextStyle(
                        color: Colors.green,
                        fontSize: 30,
                      ),
                    ),
                    icon: const Icon(
                      Icons.login,
                      color: Colors.green,
                    ),
                  ),
                  Center(
                    child: SizedBox(
                      width: 210,
                      child: Text(
                        "loginReason".tr,
                        style: const TextStyle(
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.green,
                    child: GetX<AccountInfo>(
                      builder: (controller) => Text(
                        controller.name.value.substring(0, 1),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GetX<AccountInfo>(
                        builder: (controller) => Text(
                          controller.name.value.length > 10
                              ? "${controller.name.value.substring(0, 10)}..."
                              : controller.name.value,
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      GetX<AccountInfo>(
                        builder: (controller) => Text(
                          controller.email.value.length > 20
                              ? "${controller.email.value.substring(0, 15)}...${controller.email.value.substring(controller.email.value.length - 9, controller.email.value.length)}"
                              : controller.email.value,
                          style: const TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ),
                      GetX<AccountInfo>(
                        builder: (controller) => Text(
                          controller.uid.value,
                          style: const TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  TextButton(
                    onPressed: uploadAll,
                    child: Icon(
                      (favoriteDone && bookmarkDone && notesDone) == true
                          ? Icons.cloud_done
                          : Icons.cloud_upload,
                    ),
                  ),
                ],
              ),
      ],
    );
  }
}
