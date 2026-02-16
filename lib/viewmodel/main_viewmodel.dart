import 'package:flutter/material.dart';
import '../model/greeting_data.dart';
import 'dart:async';

class MainViewModel extends ChangeNotifier {
  // 1. EL MODEL (Les dades fixes)
  final GreetingData _data = GreetingData();

  // 2. L'ESTAT (La part variable)
  bool _isVisible = false;

  // 3. GETTERS (El que la vista consumeix)
  // Si és visible, retornem el missatge. Si no, string buit.
  String get greetingText => _isVisible ? _data.message : "";

  // Decidim quin text de botó toca segons l'estat
  String get buttonText => _isVisible ? _data.btnHideText : _data.btnShowText;

  // Getter per saber si hem de pintar el text en color o no (opcional, per UI)
  bool get isVisible => _isVisible;

  // 4. ACCIÓ (Canviar l'estat)
  void toggleVisibility() {
    _isVisible = !_isVisible;
    notifyListeners(); // Avisem a la vista.
  }
}
