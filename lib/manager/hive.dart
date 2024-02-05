import 'package:flutter/material.dart';

import 'package:hive_flutter/hive_flutter.dart';

String themeBoxName = 'theme';

class Database {
  late Box themeBox;

  static final Database _instance = Database._();
  factory Database() => _instance;
  Database._();

  Future<void> init() async {
    await Hive.initFlutter();
    themeBox = await Hive.openBox(themeBoxName);
  }

  Brightness get theme => themeBox.get('theme') == 'light'
      ? Brightness.light
      : themeBox.get('theme') == 'dark'
          ? Brightness.dark
          : Brightness.dark;

  set theme(Brightness value) => value == Brightness.light
      ? themeBox.put('theme', 'light')
      : value == Brightness.dark
          ? themeBox.put('theme', 'dark')
          : themeBox.put('theme', 'system');
}
