import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kpop_profiles/providers/auth_providers.dart';
import 'package:provider/provider.dart';
import 'package:kpop_profiles/consts/validator.dart';
import 'package:kpop_profiles/services/app_functions.dart';
import 'package:kpop_profiles/widgets/image_picker.dart';
import 'package:kpop_profiles/widgets/title_text.dart';

class EditProfileScreen extends StatefulWidget {
  static const routeName = "/EditProfileScreen";
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  bool _isLoading = false;
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
    final auth = Provider.of<AuthProvider>(context, listen: false);
    _usernameController = TextEditingController(text: auth.username);
    _emailController = TextEditingController(text: auth.email);
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
    if (!_formKey.currentState!.validate()) return;
    
    setState(() {
      _isLoading = true;
    });

    FocusScope.of(context).unfocus();
    
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      
      await authProvider.updateUserData(
        username: _usernameController.text.trim(),
        imagePath: _pickedImage?.path,
        newPassword: _passwordController.text.trim().isEmpty 
            ? null 
            : _passwordController.text.trim(),
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile updated successfully!")),
      );
      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text("Error"),
          content: Text(e.toString()),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text("OK"),
            ),
          ],
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
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
      removeFCT: () => setState(() => _pickedImage = null),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(leading: const BackButton(), title: const Text("Edit profile")),
        body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const TitleText(label: "Edit your profile"),
                const SizedBox(height: 24),
                Center(
                  child: SizedBox(
                    height: size.width * 0.3,
                    width: size.width * 0.3,
                    child: ImagePickerWidget(
                      pickedImage: _pickedImage, 
                      function: () async => await localImagePicker()
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                TextFormField(
                  controller: _usernameController,
                  focusNode: _usernameFocusNode,
                  decoration: const InputDecoration(
                    hintText: "Username", 
                    prefixIcon: Icon(Icons.person)
                  ),
                  validator: (v) => MyValidators.displayNamevalidator(v),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  focusNode: _emailFocusNode,
                  enabled: false, 
                  decoration: const InputDecoration(
                    hintText: "Email", 
                    prefixIcon: Icon(IconlyLight.message),
                    fillColor: Colors.grey
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  focusNode: _passwordFocusNode,
                  obscureText: true,
                  decoration: const InputDecoration(
                    hintText: "New Password (leave empty to keep current)", 
                    prefixIcon: Icon(IconlyLight.lock)
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.save),
                    label: const Text("Save changes"),
                    onPressed: _saveChanges,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}