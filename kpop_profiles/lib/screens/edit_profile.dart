import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kpop_profiles/consts/validator.dart';
import 'package:kpop_profiles/services/app_functions.dart';
import 'package:kpop_profiles/widgets/image_picker.dart';
import 'package:kpop_profiles/widgets/subtitle_text.dart';
import 'package:kpop_profiles/widgets/title_text.dart';

class EditProfileScreen extends StatefulWidget {
  static const routeName = "/EditProfileScreen";

  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}


class _EditProfileScreenState extends State<EditProfileScreen> {
  bool obscureText = true;

  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  late FocusNode _usernameFocusNode;
  late FocusNode _emailFocusNode;
  late FocusNode _passwordFocusNode;

  final _formKey = GlobalKey<FormState>();
  XFile? _pickedImage;

 @override
void initState() {
  super.initState();

  _usernameController = TextEditingController();
  _emailController = TextEditingController();
  _passwordController = TextEditingController();

  _usernameFocusNode = FocusNode();
  _emailFocusNode = FocusNode();
  _passwordFocusNode = FocusNode();
}


  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _usernameFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (!isValid) return;

    // ovde je za back=end

    Navigator.of(context).pop();
  }

  Future<void> localImagePicker() async {
    final ImagePicker imagePicker = ImagePicker();
    await AppFunctions.imagePickerDialog(
      context: context,
      cameraFCT: () async {
        _pickedImage = await imagePicker.pickImage(source: ImageSource.camera);
        setState(() {});
      },
      galleryFCT: () async {
        _pickedImage = await imagePicker.pickImage(source: ImageSource.gallery);
        setState(() {});
      },
      removeFCT: () {
        setState(() {
          _pickedImage = null;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          leading: const BackButton(),
          title: const Text("Edit profile"),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TitleText(label: "Edit your profile"),
              const SizedBox(height: 4),
              const SubtitleText(label: "Update your information"),
              const SizedBox(height: 24),
              Center(
                child: SizedBox(
                  height: size.width * 0.3,
                  width: size.width * 0.3,
                  child: ImagePickerWidget(
                    pickedImage: _pickedImage,
                    function: () async {
                      await localImagePicker();
                    },
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _usernameController,
                      focusNode: _usernameFocusNode,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        hintText: "Username",
                        prefixIcon: Icon(Icons.person),
                      ),
                      validator: (value) {
                        return MyValidators.displayNamevalidator(value);
                      },
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_emailFocusNode);
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _emailController,
                      focusNode: _emailFocusNode,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        hintText: "Email",
                        prefixIcon: Icon(IconlyLight.message),
                      ),
                      validator: (value) {
                        return MyValidators.emailValidator(value);
                      },
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_passwordFocusNode);
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      focusNode: _passwordFocusNode,
                      textInputAction: TextInputAction.done,
                      obscureText: obscureText,
                      decoration: InputDecoration(
                        hintText: "New password (optional)",
                        prefixIcon: const Icon(IconlyLight.lock),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              obscureText = !obscureText;
                            });
                          },
                          icon: Icon(
                            obscureText
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return null;
                        }
                        return MyValidators.passwordValidator(value);
                      },
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.save),
                        label: const Text("Save changes"),
                        onPressed: _saveChanges,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
