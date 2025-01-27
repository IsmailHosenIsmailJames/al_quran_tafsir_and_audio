import 'package:al_quran_tafsir_and_audio/src/resources/api_response/some_api_response.dart';
import 'package:al_quran_tafsir_and_audio/src/screens/home/tabs/collection_tab/controller/collection_controller.dart';
import 'package:al_quran_tafsir_and_audio/src/screens/home/tabs/collection_tab/controller/collection_model.dart';
import 'package:al_quran_tafsir_and_audio/src/screens/home/tabs/collection_tab/create_new_collection.dart/add_new_ayah.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:toastification/toastification.dart';

class CreateNewCollectionPage extends StatefulWidget {
  final CollectionInfoModel? previousData;
  const CreateNewCollectionPage({super.key, required this.previousData});

  @override
  State<CreateNewCollectionPage> createState() =>
      _CreateNewCollectionPageState();
}

class _CreateNewCollectionPageState extends State<CreateNewCollectionPage> {
  final CollectionController collectionController = Get.find();

  late CollectionInfoModel editingCollection =
      collectionController.editingCollection.value.copyWith(
    name: widget.previousData?.name,
    description: widget.previousData?.description,
    ayahs: widget.previousData?.ayahs,
    peopleAdded: widget.previousData?.peopleAdded,
    isPublicResources: widget.previousData?.isPublicResources,
    createdBy: widget.previousData?.createdBy,
    createdAt: widget.previousData?.createdAt,
  );

  late TextEditingController nameController =
      TextEditingController(text: editingCollection.name);
  late TextEditingController descriptionController =
      TextEditingController(text: editingCollection.description);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create New Collection"),
      ),
      body: ListView(
        padding: EdgeInsets.all(10),
        children: [
          Gap(10),
          Text(
            "Collection Name",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Gap(7),
          TextFormField(
            controller: nameController,
            decoration:
                InputDecoration(hintText: "Type collection name here..."),
            maxLength: 100,
          ),
          Gap(10),
          Text(
            "Description",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Gap(7),
          TextFormField(
            controller: descriptionController,
            decoration: InputDecoration(hintText: "Type description here..."),
            maxLength: 5000,
          ),
          Gap(10),
          Text(
            "Ayahs",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Gap(7),
          Container(
            padding: EdgeInsets.all(7),
            margin: EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.grey.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(7),
            ),
            child: Column(
              children: <Widget>[
                    if (editingCollection.ayahs?.isNotEmpty != true)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: const Text("No Ayahs Added"),
                      ),
                  ] +
                  List<Widget>.generate(
                    editingCollection.ayahs?.length ?? 0,
                    (index) {
                      return Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: CircleAvatar(
                              radius: 15,
                              child: FittedBox(child: Text("${index + 1}")),
                            ),
                          ),
                          Gap(10),
                          Text(
                            "${int.parse(editingCollection.ayahs![index].split(":")[0]) + 1}. ${allChaptersInfo[int.parse(editingCollection.ayahs![index].split(":")[0])]["name_simple"]} ( ${editingCollection.ayahs![index].split(":")[1]} )",
                          ),
                          Gap(15),
                          Spacer(),
                          SizedBox(
                            width: 40,
                            height: 30,
                            child: IconButton(
                              onPressed: () {
                                setState(() {
                                  editingCollection.ayahs?.removeAt(index);
                                });
                              },
                              style: IconButton.styleFrom(
                                iconSize: 18,
                                padding: EdgeInsets.zero,
                              ),
                              icon: Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ) +
                  <Widget>[
                    Gap(15),
                    Container(
                      height: 30,
                      width: double.infinity,
                      margin: const EdgeInsets.all(8.0),
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.only(left: 15, right: 15),
                        ),
                        onPressed: () async {
                          dynamic result = await Get.to(
                            () => AddNewAyahForCollection(),
                          );
                          if (result.runtimeType == String) {
                            setState(() {
                              editingCollection.ayahs ??= [];
                              editingCollection.ayahs?.add(result as String);
                            });
                            toastification.show(
                              context: context,
                              title: const Text("Ayah Added"),
                              autoCloseDuration: const Duration(seconds: 2),
                              type: ToastificationType.success,
                            );
                          }
                        },
                        icon: Icon(Icons.add),
                        label: const Text("Add New Ayah"),
                      ),
                    ),
                  ],
            ),
          ),
          Gap(10),
          ElevatedButton.icon(
            onPressed: () async {
              if (nameController.text.isEmpty) {
                toastification.show(
                  context: context,
                  title: const Text("Collection name is required"),
                  autoCloseDuration: const Duration(seconds: 2),
                  type: ToastificationType.error,
                );
                return;
              } else if (editingCollection.ayahs?.isNotEmpty != true) {
                toastification.show(
                  context: context,
                  title: const Text("No Ayahs Added"),
                  autoCloseDuration: const Duration(seconds: 2),
                  type: ToastificationType.error,
                );
              } else {
                final box = Hive.box("collections_db");
                String name = nameController.text.trim();
                String description = descriptionController.text.trim();
                if (box.containsKey(name)) {
                  toastification.show(
                    context: context,
                    title: const Text("Collection name already exists"),
                    autoCloseDuration: const Duration(seconds: 2),
                    type: ToastificationType.error,
                  );
                } else {
                  editingCollection.name = name;
                  if (description.isNotEmpty) {
                    editingCollection.description = description;
                  }
                  box.put(editingCollection.id, editingCollection.toJson());
                  if (widget.previousData == null) {
                    collectionController.collectionList.add(editingCollection);
                  } else {
                    collectionController.collectionList[
                        collectionController.collectionList.indexWhere(
                      (element) => widget.previousData?.id == element.id,
                    )] = editingCollection;
                  }
                  toastification.show(
                    context: context,
                    title: Text(widget.previousData == null
                        ? "Collection Created"
                        : "Saved Changes"),
                    autoCloseDuration: const Duration(seconds: 2),
                    type: ToastificationType.success,
                  );
                  Get.back();
                }
              }
            },
            icon: Icon(Icons.done),
            label: Text(widget.previousData == null
                ? "Create Collection"
                : "Save Changes"),
          ),
        ],
      ),
    );
  }
}
