import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_0488_components_custom/model/galery_data.dart';

/// Model d'estat per a la configuració visual del panell (RA 3.3)
class PanellConfig {
  // Estat: Qué és el component?  Estil, Com està el component?
  // variables que no haurien de canviar habitualment un cop instanciat el component
  final String titol;
  final Color colorFons;

  // constructor  "const" que m'ha de donar aquestes variables.
  const PanellConfig({
    required this.titol,
    this.colorFons = const Color.fromARGB(255, 218, 207, 185),
  });
}

/// Widget personalitzat que gestiona events complexos de ratolí i punter (RA 4)
class PanellInteractiuWidget extends StatelessWidget {
  // 1. L'objecte de configuració obligatori
  final PanellConfig config;

  // 2. Paràmetres d'estil opcionals. Aquests si que varien durant la vida del widget, però amb copies.
  final Color colorVora;
  final double alcada;
  final List<ElementImatge> imatges; // Dada de negoci
  final List<int> seleccionats; // Estat de selecció

  // 3. Callbacks per a la gestió d'esdeveniments (RA 3.4)
  final Function(int, TipusAccio) onAccio; // Callback complex

  // El constructor
  const PanellInteractiuWidget({
    super.key, // això és l'identificador únic del giny, fem servir el mètode del pare per crear-lo.
    required this.config, // Es necessari les dades de configuració del widget.
    required this.imatges,
    required this.seleccionats,
    required this.onAccio,
    this.colorVora = Colors.transparent, // Valor per defecte
    this.alcada = 200.0, // Valor per defecte
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: alcada,
      decoration: BoxDecoration(
        color: config.colorFons,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: colorVora, width: 3),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Wrap(
          // Organització automàtica d'imatges
          spacing: 10,
          runSpacing: 10,
          children: imatges.map((img) {
            final isSelected = seleccionats.contains(img.id);
            return GestureDetector(
              onTap: () => onAccio(img.id, TipusAccio.seleccionar),
              child: Stack(
                // Superposició del "check"
                alignment: Alignment.topRight,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.blue.withOpacity(0.3)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isSelected ? Colors.blue : Colors.grey,
                        width: 2,
                      ),
                      boxShadow: const [
                        BoxShadow(blurRadius: 4, color: Colors.black12),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.file(
                        File(img.path), // LECTURA DE FITXER REAL
                        width: 90,
                        height: 90,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            const Icon(Icons.broken_image, size: 90),
                      ),
                    ),
                  ),
                  if (isSelected)
                    const Icon(
                      Icons.check_circle,
                      color: Colors.blue,
                      size: 24,
                    ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
