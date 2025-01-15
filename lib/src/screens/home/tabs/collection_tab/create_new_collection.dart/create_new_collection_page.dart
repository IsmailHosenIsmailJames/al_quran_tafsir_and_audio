import 'package:al_quran_tafsir_and_audio/src/screens/home/tabs/collection_tab/controller/collection_controller.dart';
import 'package:al_quran_tafsir_and_audio/src/screens/home/tabs/collection_tab/controller/collection_model.dart';
import 'package:al_quran_tafsir_and_audio/src/screens/home/tabs/collection_tab/create_new_collection.dart/add_new_ayah.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
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
                      return Text(
                        editingCollection.ayahs![index].toString(),
                      );
                    },
                  ) +
                  <Widget>[
                    Gap(15),
                    Container(
                      height: 30,
                      margin: const EdgeInsets.all(8.0),
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.only(left: 15, right: 15),
                        ),
                        onPressed: () async {
                          dynamic result = await Get.to(
                            () => AddNewAyahForCollection(),
                          );
                          if (result.runtimeType == Ayah) {
                            setState(() {
                              editingCollection.ayahs ??= [];
                              editingCollection.ayahs?.add(result as Ayah);
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
          )
        ],
      ),
    );
  }
}
