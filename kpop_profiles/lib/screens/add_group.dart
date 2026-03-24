import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:kpop_profiles/models/idol_model.dart';
import 'package:kpop_profiles/providers/group_provider.dart';
import 'package:kpop_profiles/providers/idol_provider.dart';
import 'package:kpop_profiles/services/app_functions.dart';
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
  List<IdolModel> _tempIdols = [];
  XFile? _groupImage;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.existingGroup?.name ?? "",
    );

    if (widget.existingGroup != null) {
      final allIdols = Provider.of<IdolProvider>(context, listen: false).idols;
      _tempIdols = allIdols
          .where((idol) => idol.groupId == widget.existingGroup!.id)
          .toList();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _localImagePicker() async {
    final ImagePicker picker = ImagePicker();
    await AppFunctions.imagePickerDialog(
      context: context,
      cameraFCT: () async {
        final image = await picker.pickImage(source: ImageSource.camera);
        if (image != null) setState(() => _groupImage = image);
      },
      galleryFCT: () async {
        final image = await picker.pickImage(source: ImageSource.gallery);
        if (image != null) setState(() => _groupImage = image);
      },
      removeFCT: () => setState(() => _groupImage = null),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.existingGroup == null ? "Add Group" : "Edit Group"),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Center(
                    child: SizedBox(
                      height: 120,
                      width: 120,
                      child: ImagePickerWidget(
                        pickedImage: _groupImage,
                        function: _localImagePicker,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: "Group Name",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.group),
                      ),
                    ),
                  ),
                  const Divider(),
                  const Text(
                    "MEMBERS",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),

                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _tempIdols.length,
                    itemBuilder: (context, index) => idolCard(index),
                  ),

                  TextButton.icon(
                    onPressed: () {
                      setState(() {
                        _tempIdols.add(
                          IdolModel(
                            id: DateTime.now().millisecondsSinceEpoch
                                .toString(),
                            name: "",
                            birthday: "",
                            groupId: widget.existingGroup?.id ?? "",
                            isFavorite: false,
                          ),
                        );
                      });
                    },
                    icon: const Icon(Icons.add),
                    label: const Text("Add Member Field"),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
      bottomSheet: _buildBottomAction(),
    );
  }

  Widget _buildBottomAction() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 50),
          backgroundColor: Colors.blue,
        ),
        onPressed: _saveData,
        child: const Text(
          "CONFIRM CHANGES",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Future<void> _saveData() async {
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Name is required")));
      return;
    }

    setState(() => _isLoading = true);
    final groupProvider = Provider.of<GroupProvider>(context, listen: false);

    try {
      if (widget.existingGroup == null) {
        await groupProvider.addGroup(
          name: _nameController.text.trim(),
          imageFile: _groupImage != null ? File(_groupImage!.path) : null,
          idols: _tempIdols,
        );
      } else {
        await groupProvider.updateGroup(
          groupId: widget.existingGroup!.id,
          name: _nameController.text.trim(),
          imageFile: _groupImage != null ? File(_groupImage!.path) : null,
          oldImageUrl: widget.existingGroup!.imageUrl,
          idols: _tempIdols,
        );
      }
      if (mounted) Navigator.pop(context);
    } catch (e) {
      debugPrint("Save error: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Widget idolCard(int index) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        title: TextField(
          decoration: const InputDecoration(hintText: "Stage Name"),
          onChanged: (v) => _tempIdols[index].name = v,
          controller: TextEditingController(text: _tempIdols[index].name)
            ..selection = TextSelection.collapsed(
              offset: _tempIdols[index].name.length,
            ),
        ),
        subtitle: TextField(
          decoration: const InputDecoration(hintText: "Birthday (YYYY-MM-DD)"),
          onChanged: (v) => _tempIdols[index].birthday = v,
          controller: TextEditingController(text: _tempIdols[index].birthday)
            ..selection = TextSelection.collapsed(
              offset: _tempIdols[index].birthday.length,
            ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () => setState(() => _tempIdols.removeAt(index)),
        ),
      ),
    );
  }
}
