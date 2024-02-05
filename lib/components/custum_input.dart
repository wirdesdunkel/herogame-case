import 'package:flutter/material.dart';

class CustomInput extends StatelessWidget {
  final TextEditingController controller;
  final bool? obscureText;
  final IconData? suffixIcon;
  final void Function()? onTapIcon;
  final String label;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final bool multiline;

  const CustomInput({
    super.key,
    required this.controller,
    required this.label,
    this.obscureText = false,
    this.validator,
    this.suffixIcon,
    this.onTapIcon,
    this.keyboardType,
    this.multiline = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8),
      child: TextFormField(
        minLines: multiline ? 3 : 1,
        maxLines: multiline ? 5 : 1,
        keyboardType: keyboardType,
        validator: validator ?? generalValidator,
        controller: controller,
        obscureText: obscureText ?? false,
        decoration: InputDecoration(
          suffixIcon: InkWell(onTap: onTapIcon, child: Icon(suffixIcon)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.primary, width: 2)),
          hintStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface),
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}

final emailRegex = RegExp(r"^\S+@\S+\.\S+$");
final onlyDigits = RegExp(r"\d");
final nonDigits = RegExp(r"\D");

String? emailValidator(String? value) {
  if (value == null || value.isEmpty) {
    return "E-posta boş bırakılamaz";
  }
  if (!emailRegex.hasMatch(value)) {
    return "Geçerli bir e-posta adresi giriniz";
  }
  return null;
}

String? generalValidator(String? value) {
  if (value == null || value.isEmpty) {
    return "Bu alan boş bırakılamaz";
  }

  return null;
}

String? passwordValidator(String? value) {
  if (value == null || value.isEmpty) {
    return "Şifre boş bırakılamaz";
  }
  if (value.length < 6) {
    return "Şifre en az 6 karakter olmalıdır";
  }

  if (!value.contains(onlyDigits)) {
    return "Şifre en az bir rakam içermelidir";
  }

  if (!value.contains(RegExp(r'[A-Z]'))) {
    return "Şifre en az bir büyük harf içermelidir";
  }

  return null;
}
