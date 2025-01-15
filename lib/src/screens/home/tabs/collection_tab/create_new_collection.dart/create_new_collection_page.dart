import 'package:al_quran_tafsir_and_audio/src/screens/home/tabs/collection_tab/controller/collection_controller.dart';
import 'package:al_quran_tafsir_and_audio/src/screens/home/tabs/collection_tab/controller/collection_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateNewCollectionPage extends StatefulWidget {
  final CollectionInfoModel previousData;
  const CreateNewCollectionPage({super.key, required this.previousData});

  @override
  State<CreateNewCollectionPage> createState() =>
      _CreateNewCollectionPageState();
}

class _CreateNewCollectionPageState extends State<CreateNewCollectionPage> {
  final CollectionController collectionController = Get.find();

  late CollectionInfoModel editingCollection =
      collectionController.editingCollection.value.copyWith(
    name: widget.previousData.name,
    description: widget.previousData.description,
    ayahs: widget.previousData.ayahs,
    peopleAdded: widget.previousData.peopleAdded,
    isPublicResources: widget.previousData.isPublicResources,
    createdBy: widget.previousData.createdBy,
    createdAt: widget.previousData.createdAt,
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
        children: [
          TextFormField(
            controller: nameController,
          ),
          TextFormField(
            controller: descriptionController,
          ),
          Column(
            children: List<Widget>.generate(
                  editingCollection.ayahs?.length ?? 0,
                  (index) {
                    return Text(
                      editingCollection.ayahs![index].toString(),
                    );
                  },
                ) +
                <Widget>[
                  TextButton(
                    onPressed: () {},
                    child: const Text("Add New Ayah"),
                  ),
                ],
          )
        ],
      ),
    );
  }
}
