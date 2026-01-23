import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:kpop_profiles/consts/validator.dart';
import 'package:kpop_profiles/providers/auth_providers.dart';
import 'package:kpop_profiles/screens/register.dart';
import 'package:kpop_profiles/screens/root_screen.dart';
import 'package:kpop_profiles/services/assets_manager.dart';
import 'package:kpop_profiles/widgets/subtitle_text.dart';
import 'package:kpop_profiles/widgets/title_text.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  static const String routeName = '/LoginScreen';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool obscureText = true;

  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final FocusNode _emailFocusNode;
  late final FocusNode _passwordFocusNode;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  Future<void> _loginFct() async {
    if (!_formKey.currentState!.validate()) return;
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    if (email == 'user@gmail.com' && password == 'user123') {
      auth.loginUser(isAdmin: false, username: '@user');
      Navigator.of(context).pushReplacementNamed(RootScreen.routeName);
    } else if (email == 'admin@gmail.com' && password == 'admin123') {
      auth.loginUser(isAdmin: true, username: '@admin');
      Navigator.of(context).pushReplacementNamed(RootScreen.routeName);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Wrong credentials')));
      return;
    }
    Navigator.of(context).pushReplacementNamed(RootScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: BackButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(RootScreen.routeName);
                    },
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
                const SizedBox(height: 24),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: TitleText(label: "Welcome back!"),
                ),
                const SizedBox(height: 16),
                Form(
                  key: _formKey,
                  child: Column(
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
                        onFieldSubmitted: (_) {
                          FocusScope.of(
                            context,
                          ).requestFocus(_passwordFocusNode);
                        },
                        validator: MyValidators.emailValidator,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _passwordController,
                        focusNode: _passwordFocusNode,
                        obscureText: obscureText,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          hintText: "***********",
                          prefixIcon: const Icon(IconlyLight.lock),
                          suffixIcon: IconButton(
                            icon: Icon(
                              obscureText
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                obscureText = !obscureText;
                              });
                            },
                          ),
                        ),
                        onFieldSubmitted: (_) async => _loginFct(),
                        validator: MyValidators.passwordValidator,
                      ),
                      const SizedBox(height: 16),
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
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.login),
                          label: const Text("Login"),
                          onPressed: _loginFct,
                        ),
                      ),
                      const SizedBox(height: 24),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          child: const Text("Continue as guest"),
                          onPressed: () {
                            Navigator.of(
                              context,
                            ).pushReplacementNamed(RootScreen.routeName);
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SubtitleText(label: "New here?"),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pushNamed(RegisterScreen.routeName);
                            },
                            child: const SubtitleText(
                              label: "Sign up",
                              fontStyle: FontStyle.italic,
                              textDecoration: TextDecoration.underline,
                            ),
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
