import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:herogame_case/components/custum_input.dart';
import 'package:herogame_case/components/layout.dart';
import 'package:herogame_case/manager/firebase.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  bool obscureText = true;
  bool isLoading = false;

  @override
  initState() {
    super.initState();
    if (kDebugMode) {
      emailController.text = '2@2.com';
      passwordController.text = '123456AA';
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Layout(
        noPop: true,
        child: Form(
          key: _formkey,
          child: Container(
            height: size.height * .8,
            width: size.width,
            color: Theme.of(context).scaffoldBackgroundColor,
            child: Column(
              children: [
                SizedBox(
                  height: size.height * .2,
                ),
                CustomInput(
                  validator: emailValidator,
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  obscureText: false,
                  label: 'Email',
                ),
                CustomInput(
                  label: 'Şifre',
                  controller: passwordController,
                  obscureText: obscureText,
                  suffixIcon:
                      obscureText ? Icons.visibility : Icons.visibility_off,
                  onTapIcon: () {
                    setState(() {
                      obscureText = !obscureText;
                    });
                  },
                ),
                ElevatedButton(
                  child: const Text(
                    'Giriş Yap',
                  ),
                  onPressed: () async {
                    if (isLoading) return;
                    if (_formkey.currentState!.validate()) {
                      setState(() => isLoading = true);
                      final timer = Timer(const Duration(seconds: 10), () {
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'İşlem zaman aşımına uğradı. Lütfen tekrar deneyin.'),
                            ),
                          );
                        }

                        return;
                      });

                      try {
                        await FirebaseManager().signIn(
                          email: emailController.text,
                          password: passwordController.text,
                        );
                        timer.cancel();
                        setState(() => isLoading = false);
                      } catch (e) {
                        timer.cancel();

                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(e.toString()),
                            ),
                          );
                          setState(() => isLoading = false);
                        }
                      }
                    }
                  },
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Hesabınız yok mu?'),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/register');
                        },
                        child: const Text('Kayıt Ol'),
                      )
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
