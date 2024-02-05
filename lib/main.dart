import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:herogame_case/firebase_options.dart';
import 'package:herogame_case/manager/hive.dart';
import 'package:herogame_case/manager/login_manager.dart';
import 'package:herogame_case/models/brightness_model.dart';
import 'package:herogame_case/screen/home_screen.dart';
import 'package:herogame_case/screen/login_screen.dart';
import 'package:herogame_case/screen/register_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Database().init();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const RootApp());
}

class RootApp extends StatelessWidget {
  const RootApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<BrightnessModel>(
          create: (_) => BrightnessModel(),
        ),
      ],
      child: Consumer<BrightnessModel>(
        builder: (context, brightnessModel, child) {
          return MaterialApp(
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate
            ],
            locale: const Locale('tr'),
            debugShowCheckedModeBanner: false,
            routes: routes,
            theme: ThemeData(
                brightness: brightnessModel.theme,
                colorSchemeSeed: const Color.fromRGBO(188, 0, 74, 1.0)),
            home: const LoginManager(),
          );
        },
      ),
    );
  }

  Map<String, WidgetBuilder> get routes => {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/register': (context) => const RegisterScreen(),
      };
}
