import 'package:flutter/material.dart';

class PanellUiState {
  final String missatgeGest; // Estat del gest (Text)
  final double posX; // Estat de la posició (Coordenada X)
  final double posY; // Estat de la posició (Coordenada Y)
  final Color colorVora; // Estat de la vora
  final double alcada; // Estat de la posició (Coordenada Y)

  const PanellUiState({
    this.missatgeGest = "Esperant interacció...",
    this.posX = 0.0,
    this.posY = 0.0,
    this.colorVora = Colors.transparent,
    this.alcada = 400.0,
  });

  // Mètode clau (copyWith): Permet crear una còpia de l'estat actual
  // canviant només les propietats que ens interessin.
  PanellUiState copyWith({
    String? missatgeGest,
    double? posX,
    double? posY,
    Color? colorVora,
    double? alcada,
  }) {
    return PanellUiState(
      missatgeGest: missatgeGest ?? this.missatgeGest,
      posX: posX ?? this.posX,
      posY: posY ?? this.posY,
      colorVora: colorVora ?? this.colorVora,
      alcada: alcada ?? this.alcada,
    );
  }
}
