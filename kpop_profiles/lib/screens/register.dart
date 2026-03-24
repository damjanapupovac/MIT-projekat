import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kpop_profiles/consts/validator.dart';
import 'package:kpop_profiles/providers/auth_providers.dart';
import 'package:kpop_profiles/screens/root_screen.dart';
import 'package:kpop_profiles/services/app_functions.dart';
import 'package:kpop_profiles/services/assets_manager.dart';
import 'package:kpop_profiles/widgets/image_picker.dart';
import 'package:kpop_profiles/widgets/subtitle_text.dart';
import 'package:kpop_profiles/widgets/title_text.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  static const routeName = "/RegisterScreen";
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool obscureText = true;
  bool isLoading = false;

  late final TextEditingController _nameController,
      _emailController,
      _passwordController,
      _repeatPasswordController;
  late final FocusNode _nameFocusNode,
      _emailFocusNode,
      _passwordFocusNode,
      _repeatPasswordFocusNode;

  final _formkey = GlobalKey<FormState>();
  XFile? _pickedImage;

  @override
  void initState() {
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _repeatPasswordController = TextEditingController();

    _nameFocusNode = FocusNode();
    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
    _repeatPasswordFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _repeatPasswordController.dispose();
    _nameFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _repeatPasswordFocusNode.dispose();
    super.dispose();
  }

  Future<void> _registerFCT() async {
    final isValid = _formkey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      setState(() {
        isLoading = true;
      });

      final auth = Provider.of<AuthProvider>(context, listen: false);

      final error = await auth.signUp(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        username: _nameController.text.trim(),
        imageFile: _pickedImage != null ? File(_pickedImage!.path) : null,
      );

      if (mounted) {
        setState(() {
          isLoading = false;
        });

        if (error == null) {
          Navigator.of(context).pushReplacementNamed(RootScreen.routeName);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Account created successfully!"),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(error), backgroundColor: Colors.red),
          );
        }
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
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: BackButton(
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
                const SizedBox(height: 60),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "${AssetsManager.imagesPath}/logo.png",
                      height: 60,
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      "K-pop profiles",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TitleText(label: "Welcome!"),
                      SubtitleText(label: "Create your profile"),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  height: size.width * 0.3,
                  width: size.width * 0.3,
                  child: ImagePickerWidget(
                    pickedImage: _pickedImage,
                    function: () async => await localImagePicker(),
                  ),
                ),
                const SizedBox(height: 30),
                Form(
                  key: _formkey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _nameController,
                        focusNode: _nameFocusNode,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          hintText: 'username',
                          prefixIcon: Icon(Icons.person),
                        ),
                        onFieldSubmitted: (_) => FocusScope.of(
                          context,
                        ).requestFocus(_emailFocusNode),
                        validator: (value) =>
                            MyValidators.displayNamevalidator(value),
                      ),
                      const SizedBox(height: 16.0),
                      TextFormField(
                        controller: _emailController,
                        focusNode: _emailFocusNode,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          hintText: "E-mail address",
                          prefixIcon: Icon(IconlyLight.message),
                        ),
                        onFieldSubmitted: (_) => FocusScope.of(
                          context,
                        ).requestFocus(_passwordFocusNode),
                        validator: (value) =>
                            MyValidators.emailValidator(value),
                      ),
                      const SizedBox(height: 16.0),
                      TextFormField(
                        controller: _passwordController,
                        focusNode: _passwordFocusNode,
                        obscureText: obscureText,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          hintText: "Password",
                          prefixIcon: const Icon(IconlyLight.lock),
                          suffixIcon: IconButton(
                            onPressed: () =>
                                setState(() => obscureText = !obscureText),
                            icon: Icon(
                              obscureText
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                          ),
                        ),
                        onFieldSubmitted: (_) => FocusScope.of(
                          context,
                        ).requestFocus(_repeatPasswordFocusNode),
                        validator: (value) =>
                            MyValidators.passwordValidator(value),
                      ),
                      const SizedBox(height: 16.0),
                      TextFormField(
                        controller: _repeatPasswordController,
                        focusNode: _repeatPasswordFocusNode,
                        obscureText: obscureText,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          hintText: "Repeat password",
                          prefixIcon: const Icon(IconlyLight.lock),
                          suffixIcon: IconButton(
                            onPressed: () =>
                                setState(() => obscureText = !obscureText),
                            icon: Icon(
                              obscureText
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                          ),
                        ),
                        onFieldSubmitted: (_) async => await _registerFCT(),
                        validator: (value) =>
                            MyValidators.repeatPasswordValidator(
                              value: value,
                              password: _passwordController.text,
                            ),
                      ),
                      const SizedBox(height: 36.0),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.all(12.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                          icon: isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Icon(IconlyLight.addUser),
                          label: Text(isLoading ? "Registering..." : "Sign up"),
                          onPressed: isLoading
                              ? null
                              : () async => await _registerFCT(),
                        ),
                      ),
                    ],
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
