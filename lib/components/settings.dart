import 'package:flutter/material.dart';
import 'package:herogame_case/manager/firebase.dart';
import 'package:herogame_case/models/brightness_model.dart';
import 'package:provider/provider.dart';

class SettingsPopup extends StatefulWidget {
  const SettingsPopup({super.key});

  @override
  State<SettingsPopup> createState() => _SettingsPopupState();
}

class _SettingsPopupState extends State<SettingsPopup> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isLight = context.watch<BrightnessModel>().theme == Brightness.light;

    return AlertDialog(
      content: SizedBox(
        width: size.width * 0.4,
        height: size.height * 0.4,
        child: Column(
          children: [
            const Text("Ayarlar"),
            const Divider(),
            Row(
              children: [
                const Text("Tema Seçimi :"),
                const Spacer(),
                IconButton(
                  icon: Icon(
                    isLight
                        ? Icons.dark_mode_outlined
                        : Icons.light_mode_outlined,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  onPressed: () {
                    if (isLight) {
                      context.read<BrightnessModel>().setTheme(Brightness.dark);
                    } else {
                      context
                          .read<BrightnessModel>()
                          .setTheme(Brightness.light);
                    }
                  },
                )
              ],
            ),
            if (FirebaseManager().isSignedIn)
              Row(
                children: [
                  const Text("Çıkış Yap :"),
                  const Spacer(),
                  IconButton(
                      icon: Icon(
                        Icons.logout,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        FirebaseManager().signOut();
                      }),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
