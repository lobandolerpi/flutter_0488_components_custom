import 'package:flutter/material.dart';
import 'package:flutter_0488_components_custom/model/galery_data.dart';

class PanellUiState {
  final String missatgeGest; // Estat del gest (Text)
  final double posX; // Estat de la posició (Coordenada X)
  final double posY; // Estat de la posició (Coordenada Y)
  final Color colorVora; // Estat de la vora
  final double alcada; // Estat de la posició (Coordenada Y)
  final List<int> seleccionats;
  final List<ElementImatge> llistaImatges;
  final int? imatgeMostradaId;

  const PanellUiState({
    this.missatgeGest = "Esperant interacció...",
    this.posX = 0.0,
    this.posY = 0.0,
    this.colorVora = Colors.transparent,
    this.alcada = 400.0,
    this.seleccionats = const <int>[], // 1C, ATENCIÓ
    this.llistaImatges = const <ElementImatge>[], // 1C, ATENCIÓ
    // Les llista les hem de declarar inmutables a l'arquitectura MVVM reactiva.
    // El metode copyWith hauria de rebre una llista nova const
    // quan la modificquem hem de crear una nova i modificarla.
    this.imatgeMostradaId,
  });

  // Mètode clau (copyWith): Permet crear una còpia de l'estat actual
  // canviant només les propietats que ens interessin.
  PanellUiState copyWith({
    String? missatgeGest,
    double? posX,
    double? posY,
    Color? colorVora,
    double? alcada,
    List<int>? seleccionats,
    List<ElementImatge>? llistaImatges,
    int? imatgeMostradaId,
  }) {
    return PanellUiState(
      missatgeGest: missatgeGest ?? this.missatgeGest,
      posX: posX ?? this.posX,
      posY: posY ?? this.posY,
      colorVora: colorVora ?? this.colorVora,
      alcada: alcada ?? this.alcada,
      seleccionats:
          seleccionats ?? this.seleccionats, // ULL AMB AIXÔ JA EN PARLAREM
      llistaImatges:
          llistaImatges ?? this.llistaImatges, // ULL AMB AIXÔ JA EN PARLAREM
      imatgeMostradaId: imatgeMostradaId ?? this.imatgeMostradaId,
    );
  }
}
