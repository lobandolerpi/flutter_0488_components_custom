import 'package:flutter/material.dart';
import 'package:flutter_0488_components_custom/model/galery_data.dart';
import 'package:flutter_0488_components_custom/model/panell_ui_state_data.dart';
import 'dart:math';
import 'dart:io'; // Per fitxers
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

  void carregarImatgesDirectori(String str) {
    try {
      final directori = Directory(str); // Això és semblant al File de Java
      if (directori.existsSync()) {
        List<FileSystemEntity> fitxers = directori
            .listSync(); // Que hi ha a la carpeta
        List<ElementImatge> imatges =
            <ElementImatge>[]; // llista d'objectes buida redimensionable

        int comptador = 0;
        for (FileSystemEntity f in fitxers) {
          // loop per fitxer al directori
          if (f.path.endsWith(".png")) {
            // Si es fitxer png creo objecte imatge
            ElementImatge imgNew = ElementImatge(
              id: comptador,
              titol: f.path.split(Platform.pathSeparator).last,
              path: f.path,
            );
            comptador++;
            imatges.add(imgNew);
          }
        }
        // Quan estic de modificar la llista, la faig final
        final List<ElementImatge> imatgesFinal = List.of(imatges);
        // actualitzo estat i notifico
        _estatPanell = _estatPanell.copyWith(llistaImatges: imatgesFinal);
        notifyListeners();
      }
    } catch (e) {
      // Capturo l'errada
      _estatPanell = _estatPanell.copyWith(
        missatgeGest: "Error llegint carpeta",
        colorVora: Colors.red,
      );
    }
  }

  void gestionarSeleccio(int id, TipusAccio accio) {
    if (accio == TipusAccio.seleccionar) {
      // Creem una COPIA de la llista (per referència)
      final novaLlista = List<int>.from(_estatPanell.seleccionats);

      if (novaLlista.contains(id)) {
        novaLlista.remove(id);
      } else {
        novaLlista.add(id);
      }

      _estatPanell = _estatPanell.copyWith(seleccionats: novaLlista);
      notifyListeners();
    }
  }
}
