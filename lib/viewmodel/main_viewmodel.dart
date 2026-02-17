import 'package:flutter/material.dart';
import 'package:flutter_0488_components_custom/model/panell_ui_state_data.dart';
import 'dart:math';
import 'dart:async';

class MainViewModel extends ChangeNotifier {
  // 1. EL MODEL (Les dades del panell).
  PanellUiState _estatPanell;
  PanellUiState get estatPanell => _estatPanell;

  // Per estàndards de desacoblament model-viewmodel
  // és millor que el constructor rebi les classes d'estats, no que les crei.
  // creem les instancies d'estat al main.
  MainViewModel(this._estatPanell);

  // MÈTODES PER CANVIAR DADES DE L'ESTAT.
  void actualitzarMissatge(String nouMissatge) {
    // Creem un nou estat copiant l'anterior i canviant només el missatge
    _estatPanell = _estatPanell.copyWith(missatgeGest: nouMissatge);
    notifyListeners();
  }

  void actualitzarCoordenades(Offset pos) {
    _estatPanell = _estatPanell.copyWith(posX: pos.dx, posY: pos.dy);
    notifyListeners();
  }

  void canviarColorAleatori() {
    final llistaColors = [
      Colors.red,
      Colors.cyan,
      Colors.yellow,
      Colors.black,
      Colors.green,
      Colors.deepPurple,
    ];
    final random = Random();
    final colorActual = _estatPanell.colorVora;
    Color nouColorTMP;
    do {
      nouColorTMP = llistaColors[random.nextInt(llistaColors.length)];
    } while (nouColorTMP == colorActual);
    final nouColorFinal = nouColorTMP;

    _estatPanell = _estatPanell.copyWith(colorVora: nouColorFinal);
    notifyListeners();
  }
}
