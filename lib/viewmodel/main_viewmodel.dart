import 'package:flutter/material.dart';
import 'package:flutter_0488_components_custom/model/galery_data.dart';
import 'package:flutter_0488_components_custom/model/panell_ui_state_data.dart';
import 'dart:math';
import 'dart:io'; // Per fitxers
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as p; // Per poder afagar parts de la ruta.

class MainViewModel extends ChangeNotifier {
  // 1. EL MODEL (Les dades del panell).
  PanellUiState _estatPanell;
  PanellUiState get estatPanell => _estatPanell;

  // Per estàndards de desacoblament model-viewmodel
  // és millor que el constructor rebi les classes d'estats, no que les crei.
  // creem les instancies d'estat al main.
  MainViewModel(this._estatPanell) {
    carregarConfiguracioTxt();
  }

  // S1E Mètode per actualitzar posicions x i y
  void actualitzarMarcador(double x, double y) {
    _estatPanell = _estatPanell.copyWith(
      posX: x,
      posY: y,
      missatgeGest:
          "Marcador a: ${x.toStringAsFixed(1)}, ${y.toStringAsFixed(1)}",
    );
    notifyListeners();
  }

  // S1E. Mètode per reordenar la llista d'imatges
  void reordenarFotos(int oldIndex, int newIndex) {
    if (oldIndex == newIndex) return; // Si no es mou, no fem res

    // 1. Creem la còpia mutable per respectar la immutabilitat de l'estat
    final novaLlista = List<ElementImatge>.from(_estatPanell.llistaImatges);

    // 2. Extraiem l'element de la seva posició original
    final imatgeMoguda = novaLlista.removeAt(oldIndex);
    /*
    // 3. ATENCIÓ: Ajustem el nou índex si estem movent cap endavant
    // Com que hem tret un element, tots els de la dreta han baixat una posició
    int indexFinal = newIndex;
    if (newIndex > oldIndex) {
      indexFinal -= 1;
    } */

    // 4. Inserim i actualitzem estat
    novaLlista.insert(newIndex, imatgeMoguda);
    _estatPanell = _estatPanell.copyWith(llistaImatges: novaLlista);
    notifyListeners();
  }

  // Mètode per canviar la imatge pel Drag & Drop
  void canviarImatgeMostrada(int id) {
    _estatPanell = _estatPanell.copyWith(imatgeMostradaId: id);
    notifyListeners();
  }

  // Mètode pel Swipe (Dreta / Esquerra) amb int direcció +1/-1
  void navegarImatge(int direccio) {
    if (_estatPanell.llistaImatges.isEmpty) return;

    // 1. Quin és l'ID (DNI) de la foto que estem mirant?
    int idActual =
        _estatPanell.imatgeMostradaId ?? _estatPanell.llistaImatges.first.id;

    // 2. A quin ÍNDEX (posició 0, 1, 2...) està AQUEST ID en la llista ACTUAL (ja reordenada)?
    int indexActual = _estatPanell.llistaImatges.indexWhere(
      (img) => img.id == idActual,
    );
    if (indexActual == -1) indexActual = 0; // Per seguretat

    // 3. Ens movem per la posició visual (+1 o -1)
    int nouIndex = indexActual + direccio;

    // 4. Gestionem els extrems (per si fem swipe a la primera o última foto)
    if (nouIndex < 0) {
      nouIndex = _estatPanell.llistaImatges.length - 1;
    } else if (nouIndex >= _estatPanell.llistaImatges.length) {
      nouIndex = 0;
    }

    // 5. Mirem quin ID (DNI) hi ha a la nova posició, i l'enviem a l'estat
    canviarImatgeMostrada(_estatPanell.llistaImatges[nouIndex].id);
  }

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
        final List<ElementImatge> imatgesFinal = List.of(imatges.reversed);
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

  void gestionarSeleccio(
    int id,
    TipusAccio accio, {
    bool multiSelect = false, //S1D, paràmetre opcional per selecció múltiple
  }) {
    if (accio == TipusAccio.seleccionar) {
      // Creem una COPIA de la llista (per referència)
      List<int> novaLlista = List<int>.from(_estatPanell.seleccionats);

      if (multiSelect) {
        // S1D lògica selecció múltiple (d'un en un)
        if (novaLlista.contains(id)) {
          novaLlista.remove(id);
        } else {
          novaLlista.add(id);
        }
      } else {
        // S1D lògica selecció única
        novaLlista = [id];
      }

      _estatPanell = _estatPanell.copyWith(seleccionats: novaLlista);
      notifyListeners();
    }
  }

  //  S1D. Nou mètode per esborrar (RA 4.2)
  void eliminarSeleccionats() {
    if (_estatPanell.seleccionats.isEmpty) {
      return; // Si no tinc selecció, no he de fer res
    }
    // Filtrem la llista d'imatges: només es queden les que NO estan a la llista de seleccionats
    final novaLlistaImatges = _estatPanell
        .llistaImatges // nova variable dinal des d'una llista.
        .where(
          (img) => !_estatPanell.seleccionats.contains(img.id),
        ) // selecciono on img.id no està a seleccionats.
        .toList(); // ho transformo en una llista per la variable de sortida.

    _estatPanell = _estatPanell.copyWith(
      llistaImatges: novaLlistaImatges,
      seleccionats: const [], // Netegem la selecció després d'esborrar
      missatgeGest: "S'han eliminat els elements seleccionats",
    );

    notifyListeners();
  }

  // Future<void> estableix que la funció és asíncrona
  // Tornarà void quan acabi, però potser triga.
  Future<void> triarCarpetaICarregar() async {
    try {
      // 1. Obrim el selector de directoris natiu
      String? rutaEscollida = // Torna un string
          await FilePicker // Await diu que
              // no s’executi aquesta línia fins rebre avís
              // que hi ha hagut resposta del S.O.
              .platform // platform tria el codi nadiu del S.O.
              .getDirectoryPath // Això obre diàleg de FilePicker
              (
                // paràmetres del diàleg File Picker
                dialogTitle: 'Selecciona la carpeta d\'imatges',
              );

      if (rutaEscollida == null) return; // L'usuari ha cancel·lat

      final directori = Directory(
        rutaEscollida,
      ); // Això és semblant al File de Java

      if (directori.existsSync()) {
        // 2. Llegim i filtrem només imatges
        List<FileSystemEntity> fitxers = directori
            .listSync(); // Què hi ha a la carpeta
        List<ElementImatge> imatges =
            <ElementImatge>[]; // Llista d'objectes buida
        // de moment llista redimensionable
        int comptador = 0;

        for (var f in fitxers) {
          // loop per fitxer al directori
          if (f is File) {
            String extensio = f.path.toLowerCase();
            if (extensio.endsWith('.png') ||
                extensio.endsWith('.jpg') ||
                extensio.endsWith('.jpeg')) {
              // Si és fitxer imatge, creo objecte imatge
              ElementImatge imgNew = ElementImatge(
                id: comptador,
                titol: p.basename(f.path), // agafa només el nom
                path: f.path,
              );
              comptador++;
              imatges.add(imgNew);
            }
          }
        }
        // Quan estic faig la lista final i la reverteixo
        final List<ElementImatge> imatgesFinal = List.of(imatges.reversed);

        // 3. Actualitzem l'estat i notifiquem
        _estatPanell = _estatPanell.copyWith(
          rutaDades: rutaEscollida,
          llistaImatges: imatgesFinal,
          missatgeGest: "Carpeta carregada correctament",
        );
        notifyListeners();
      }
    } catch (e) {
      // Capturo l'errada
      _estatPanell = _estatPanell.copyWith(
        missatgeGest: "Error llegint carpeta",
        colorVora: Colors.red,
      );
      notifyListeners(); // IMPORTANT: Notifiquem també si hi ha error
      // perquè la UI es redibuixi!
    }
  }

  Future<void> desarConfiguracioTxt() async {
    if (_estatPanell.rutaConfig.isEmpty) return;
    final fitxerConfig = File(_estatPanell.rutaConfig);
    // Creem una cadena amb salts de línia
    String contingut =
        "${_estatPanell.colorInfoFons.toARGB32()}\n"; // Linia 0 color fons
    contingut +=
        "${_estatPanell.colorInfoText.toARGB32()}\n"; // Linia 1 color text
    contingut += "${_estatPanell.rutaDades}\n"; // Línia 2 ruta fotos
    try {
      await fitxerConfig.writeAsString(contingut); // Desem a persistència
      notifyListeners();
    } catch (e) {
      fitxerConfig.parent.createSync(recursive: true);
      await fitxerConfig.writeAsString(contingut); // Desem a persistència
      notifyListeners();
    }
  }

  void carregarConfiguracioTxt() {
    if (_estatPanell.rutaConfig.isEmpty) return;

    final fitxerConfig = File(_estatPanell.rutaConfig);
    if (!fitxerConfig.existsSync()) return;

    // Llegim les línies directament en una llista d'Strings
    List<String> linies = fitxerConfig.readAsLinesSync();

    if (linies.length >= 3) {
      // Reconstruïm les dades transformant els tipus
      Color colorRecuperat1 = Color(int.parse(linies[0]));
      Color colorRecuperat2 = Color(int.parse(linies[1]));
      String pathRecuperat = linies[2];

      _estatPanell = _estatPanell.copyWith(
        colorInfoFons: colorRecuperat1,
        colorInfoText: colorRecuperat2,
        rutaDades: pathRecuperat,
      );
      notifyListeners();
    }
  }

  void actualitzarConfiguracioColors(Color nouFons, Color nouText) {
    _estatPanell = _estatPanell.copyWith(
      colorInfoFons: nouFons,
      colorInfoText: nouText,
    );
    notifyListeners();
    desarConfiguracioTxt(); // Mètode que ja tenies definit
  }

  /*
  // Mètode per a l'Slider del Fons
  void canviarColorFons(double r, double g, double b) {
    int rInt = r.toInt();
    int gInt = g.toInt();
    int bInt = b.toInt();
    _estatPanell = _estatPanell.copyWith(
      // Fem servir la intensitat per al vermell, verd i blau (Escala de grisos)
      colorInfoFons: Color.fromARGB(255, rInt, gInt, bInt),
    );
    notifyListeners();
  }

    // Mètode per a l'Slider del Text
  void canviarColorText(double r, double g, double b) {
    int rInt = r.toInt();
    int gInt = g.toInt();
    int bInt = b.toInt();
    _estatPanell = _estatPanell.copyWith(
      // Fem servir la intensitat per al vermell, verd i blau (Escala de grisos)
      colorInfoText: Color.fromARGB(255, rInt, gInt, bInt),
    );
    notifyListeners();
  }
*/
}
