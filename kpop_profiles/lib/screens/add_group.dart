import 'package:flutter/material.dart';
import 'package:kpop_profiles/models/idol_model.dart';
import '../models/group_model.dart';
import '../widgets/image_picker.dart';

class AddGroupScreen extends StatefulWidget {
  static const routeName = "/AddGroupScreen";
  final GroupModel? existingGroup;
  const AddGroupScreen({super.key, this.existingGroup});

  @override
  State<AddGroupScreen> createState() => _AddGroupScreenState();
}

class _AddGroupScreenState extends State<AddGroupScreen> {
  late TextEditingController _nameController;
  List<IdolModel> idols = [];

  @override
  void initState() {
    super.initState();
    // Ako editujemo, popuni podatke
    _nameController = TextEditingController(text: widget.existingGroup?.name ?? "");
    idols = widget.existingGroup != null 
        ? List.from(widget.existingGroup!.idols) 
        : [IdolModel(id: DateTime.now().toString())];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.existingGroup == null ? "Add Group" : "Edit Group")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _nameController,
              decoration: const InputDecoration(hintText: "Group Name"),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: idols.length,
              itemBuilder: (context, index) => idolCard(index),
            ),
          ),
          ElevatedButton.icon(
            onPressed: () => setState(() => idols.add(IdolModel(id: DateTime.now().toString()))),
            icon: const Icon(Icons.add),
            label: const Text("Add Idol"),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("CONFIRM CHANGES"),
            ),
          )
        ],
      ),
    );
  }

  Widget idolCard(int index) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(border: Border.all(width: 2), borderRadius: BorderRadius.circular(15)),
      child: Row(
        children: [
          SizedBox(height: 70, width: 70, child: ImagePickerWidget(pickedImage: idols[index].pickedImage, function: () {})),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              children: [
                TextField(
                  onChanged: (v) => idols[index].name = v,
                  decoration: const InputDecoration(hintText: "Name"),
                  controller: TextEditingController(text: idols[index].name)..selection = TextSelection.collapsed(offset: idols[index].name.length),
                ),
                TextField(
                  onChanged: (v) => idols[index].birthday = v,
                  decoration: const InputDecoration(hintText: "Birthday"),
                  controller: TextEditingController(text: idols[index].birthday)..selection = TextSelection.collapsed(offset: idols[index].birthday.length),
                ),
              ],
            ),
          ),
          IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => setState(() => idols.removeAt(index))),
        ],
      ),
    );
  }
}