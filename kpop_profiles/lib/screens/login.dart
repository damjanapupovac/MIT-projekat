import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:kpop_profiles/consts/validator.dart';
import 'package:kpop_profiles/screens/profile_screen.dart';
import 'package:kpop_profiles/screens/root_screen.dart';
import 'package:kpop_profiles/services/assets_manager.dart';
import 'package:kpop_profiles/widgets/subtitle_text.dart';
import 'package:kpop_profiles/widgets/title_text.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  static const String routeName ='/LoginScreen';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool obscureText = true;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final FocusNode _emailFocusNode;
  late final FocusNode _passwordFocusNode;
  final _formkey = GlobalKey<FormState>();

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    if (mounted) {
      _emailController.dispose();
      _passwordController.dispose();
      _emailFocusNode.dispose();
      _passwordFocusNode.dispose();
    }
    super.dispose();
  }

  Future<void> _loginFct() async {
    final isValid = _formkey.currentState!.validate();
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [Align(
                  alignment: Alignment.centerLeft,
                  child: BackButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    }
                  )
                ),
                const SizedBox(height: 60),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
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
                const SizedBox(height: 16),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: TitleText(label: "Welcome back!"),
                ),
                const SizedBox(height: 16),
                Form(
                  key: _formkey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextFormField(
                        controller: _emailController,
                        focusNode: _emailFocusNode,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          hintText: "Email address",
                          prefixIcon: Icon(IconlyLight.message),
                        ),
                        onFieldSubmitted: (value) {
                          FocusScope.of(context)
                              .requestFocus(_passwordFocusNode);
                        },
                        validator: (value) {
                          return MyValidators.emailValidator(value);
                        },
                      ),
                      const SizedBox(height: 16.0),
                      TextFormField(
                        obscureText: obscureText,
                        controller: _passwordController,
                        focusNode: _passwordFocusNode,
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.visiblePassword,
                        decoration: InputDecoration(
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
                          hintText: "***********",
                          prefixIcon: const Icon(IconlyLight.lock),
                        ),
                        onFieldSubmitted: (value) async {
                          await _loginFct();
                        },
                        validator: (value) {
                          return MyValidators.passwordValidator(value);
                        },
                      ),
                      const SizedBox(height: 16.0),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {},
                          child: const SubtitleText(
                            label: "Forgot password?",
                            fontStyle: FontStyle.italic,
                            textDecoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.all(12.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                          icon: const Icon(Icons.login),
                          label: const Text("Login"),
                          onPressed: () async{
                            await _loginFct();
                          },
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      SubtitleText(label: "Or connect using".toUpperCase()),
                      const SizedBox(height: 16.0),
                      SizedBox(
                        height: kBottomNavigationBarHeight + 10,
                        child: Row(
                          children: [
                            const SizedBox(width: 8),
                            Expanded(
                              child: SizedBox(
                                height: kBottomNavigationBarHeight,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.all(12.0),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                  ),
                                  child: const Text("Guest?"),
                                  onPressed: () async {
                                    Navigator.of(context)
                                        .pushNamed(RootScreen.routeName);
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SubtitleText(label: "New here?"),
                          TextButton(
                            child: const SubtitleText(
                              label: "Sign up",
                              fontStyle: FontStyle.italic,
                              textDecoration: TextDecoration.underline,
                            ),
                            onPressed: () {},
                          ),
                        ],
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
