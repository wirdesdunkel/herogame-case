import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:herogame_case/components/custum_input.dart';
import 'package:herogame_case/components/layout.dart';
import 'package:herogame_case/manager/firebase.dart';
import 'package:herogame_case/models/user_credentials.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController biography = TextEditingController();
  DateTime? selectedDate;
  bool isLoading = false;

  bool obscureText = true;
  final _formkey1 = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (kDebugMode) {
      emailController.text = '2@2.com';
      passwordController.text = '123456AA';
      biography.text = 'Biography';
      selectedDate = DateTime.now();
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      locale: const Locale('tr'),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: Layout(
            child: Form(
      key: _formkey1,
      child: Container(
          height: size.height * .8,
          width: size.width,
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Column(children: [
            SizedBox(height: size.height * 0.05),
            Text('Aramıza katılın!',
                style: Theme.of(context).textTheme.displayMedium),
            SizedBox(height: size.height * 0.05),
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
              suffixIcon: obscureText ? Icons.visibility : Icons.visibility_off,
              onTapIcon: () => setState(() => obscureText = !obscureText),
              validator: passwordValidator,
            ),
            CustomInput(
              label: 'Biografi',
              controller: biography,
              keyboardType: TextInputType.multiline,
              multiline: true,
              validator: generalValidator,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                children: [
                  const Text("Doğum Tarihi :"),
                  const Spacer(),
                  ElevatedButton(
                      onPressed: () => _selectDate(context),
                      child: Text(
                        selectedDate == null
                            ? 'Doğum Tarihi Seçin'
                            : selectedDate
                                .toString()
                                .substring(0, 10)
                                .split('-')
                                .reversed
                                .join('/'),
                      ))
                ],
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              child: !isLoading
                  ? const Text('Kayıt Ol')
                  : const CircularProgressIndicator(),
              onPressed: () async {
                if (isLoading) return;
                if (_formkey1.currentState!.validate()) {
                  if (selectedDate == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Lütfen doğum tarihinizi seçin.'),
                      ),
                    );
                    return;
                  }
                  setState(() => isLoading = true);
                  final timer = Timer(const Duration(seconds: 10), () {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              'İşlem zaman aşımına uğradı. Lütfen tekrar deneyin.'),
                        ),
                      );
                      setState(() => isLoading = false);
                    }
                    return;
                  });
                  try {
                    await FirebaseManager().signUp(
                      email: emailController.text,
                      password: passwordController.text,
                      credential: CredentialModel(
                        biography: biography.text,
                        birthDate: selectedDate,
                      ),
                    );
                    timer.cancel();
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Kayıt başarılı!'),
                        ),
                      );
                    }
                    setState(() => isLoading = false);
                  } catch (e) {
                    timer.cancel();
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(e.toString()),
                        ),
                      );
                    }
                    setState(() => isLoading = false);
                  }
                }
              },
            ),
          ])),
    )));
  }
}
