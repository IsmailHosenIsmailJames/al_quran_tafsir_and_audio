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
        title: Text('Create New Group'.tr),
      ),
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: [
          const Gap(10),
          Text(
            'Group Name'.tr,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const Gap(7),
          TextFormField(
            controller: nameController,
            decoration: InputDecoration(
                hintText: '${'Type collection name here'.tr}...'),
            maxLength: 100,
          ),
          const Gap(10),
          Text(
            'Description'.tr,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const Gap(7),
          TextFormField(
            controller: descriptionController,
            decoration:
                InputDecoration(hintText: '${'Type description here'.tr}...'),
            maxLength: 5000,
          ),
          const Gap(10),
          Text(
            'ayahs'.tr,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const Gap(7),
          Container(
            padding: const EdgeInsets.all(7),
            margin: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.grey.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(7),
            ),
            child: Column(
              children: <Widget>[
                    if (editingCollection.ayahs?.isNotEmpty != true)
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('No ayahs selected'.tr),
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
                              child: FittedBox(child: Text('${index + 1}')),
                            ),
                          ),
                          const Gap(10),
                          Text(
                            "${int.parse(editingCollection.ayahs![index].split(":")[0]) + 1}. ${allChaptersInfo[int.parse(editingCollection.ayahs![index].split(":")[0])]["name_simple"]} ( ${editingCollection.ayahs![index].split(":")[1]} )",
                          ),
                          const Gap(15),
                          const Spacer(),
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
                              icon: const Icon(
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
                    const Gap(15),
                    Container(
                      height: 30,
                      width: double.infinity,
                      margin: const EdgeInsets.all(8.0),
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.only(left: 15, right: 15),
                        ),
                        onPressed: () async {
                          dynamic result = await Get.to(
                            () => const AddNewAyahForCollection(),
                          );
                          if (result.runtimeType == String) {
                            setState(() {
                              editingCollection.ayahs ??= [];
                              editingCollection.ayahs?.add(result as String);
                            });
                            toastification.show(
                              context: context,
                              title: Text('Successful'.tr),
                              autoCloseDuration: const Duration(seconds: 2),
                              type: ToastificationType.success,
                            );
                          }
                        },
                        icon: const Icon(Icons.add),
                        label: Text('Add New Ayah'.tr),
                      ),
                    ),
                  ],
            ),
          ),
          const Gap(10),
          ElevatedButton.icon(
            onPressed: () async {
              if (nameController.text.isEmpty) {
                toastification.show(
                  context: context,
                  title: Text('Group name is required'.tr),
                  autoCloseDuration: const Duration(seconds: 2),
                  type: ToastificationType.error,
                );
                return;
              } else if (editingCollection.ayahs?.isNotEmpty != true) {
                toastification.show(
                  context: context,
                  title: Text('No ayahs selected'.tr),
                  autoCloseDuration: const Duration(seconds: 2),
                  type: ToastificationType.error,
                );
              } else {
                final box = Hive.box('collections_db');
                String name = nameController.text.trim();
                String description = descriptionController.text.trim();
                if (box.containsKey(name)) {
                  toastification.show(
                    context: context,
                    title: Text('Collection name already exists'.tr),
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
                    title: Text('Successful'.tr),
                    autoCloseDuration: const Duration(seconds: 2),
                    type: ToastificationType.success,
                  );
                  Get.back();
                }
              }
            },
            icon: const Icon(Icons.done),
            label: Text(
              widget.previousData == null
                  ? 'Create Group'.tr
                  : 'Save Changes'.tr,
            ),
          ),
        ],
      ),
    );
  }
}
