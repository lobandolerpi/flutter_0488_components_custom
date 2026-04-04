import 'dart:io';
import 'package:flutter/material.dart';
import '../../model/galery_data.dart';

// Una classe en lloc d'una funció té diversos avantatges:
//  - Si és una funció, no té entitat propia, si canvia res cal redibuixar tot
//  - Si és una instancia CONST, flutter sap que pot redibuixar només la instància
//
//  - En ser una classe tindrà un context independent, i es poden
//      consultar temes (Theme.of(context)) relatiu a la instància.
//
//  - Encapsulació i aïllament de responsabilitats
//       reutilització, etc...
//
class MiniaturaWidget extends StatelessWidget {
  final ElementImatge img;
  final bool isSelected;
  final bool isHovering;

  const MiniaturaWidget({
    super.key,
    required this.img,
    required this.isSelected,
    this.isHovering = false,
  });

  @override
  Widget build(BuildContext context) {
    // RESPONSE 1: MouseRegion per gestionar el cursor
    return MouseRegion(
      cursor: isHovering ? SystemMouseCursors.grab : SystemMouseCursors.click,

      // OPCIÓ 2: AnimatedContainer per a la microinteracció visual
      child: AnimatedContainer(
        // Animació implícita: Flutter calcula la transició automàticament
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,

        // Juguem amb el marge per fer l'efecte d'elevació
        margin: EdgeInsets.all(isHovering ? 0 : 4),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.transparent,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(8),
          // Afegim una ombra dinàmica
          boxShadow: isHovering
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4), // Ombra cap avall
                  ),
                ]
              : [], // Sense ombra si no hi ha hover
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            // La imatge es fa lleugerament més gran
            width: isHovering ? 78 : 70,
            height: isHovering ? 78 : 70,
            child: Image.file(File(img.path), fit: BoxFit.cover),
          ),
        ),
      ),
    );
  }
}
