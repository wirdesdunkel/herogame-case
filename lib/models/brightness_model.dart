import 'package:flutter/material.dart';
import 'package:herogame_case/manager/hive.dart';

class BrightnessModel extends ChangeNotifier {
  Brightness _theme = Database().theme;
  Brightness get theme => _theme;

  void setTheme(Brightness theme) {
    _theme = theme;
    Database().theme = theme;
    notifyListeners();
  }
}
