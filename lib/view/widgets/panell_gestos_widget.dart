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
    // Darrera imatge seleccionada per veure-la gran:
    final ElementImatge? imatgeGran =
        seleccionats
            .isNotEmpty // terna
        ? imatges.firstWhere(
            (imgParametreLambda) => imgParametreLambda.id == seleccionats.last,
          ) // si no es buit Lamba que torna la imatge amb el criteri LAST
        : (imatges.isNotEmpty
              ? imatges.first
              : null); // si seleccionat es buit, un altre tera, ara la primera de la llista o nul.

    // AnimatedContainer, per poder fer "animacions" transicions suaus.
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: alcada,
      decoration: BoxDecoration(
        // BoxDecoration ens permet modificat la caixa exterior del giny (cantonades, vores, etc.)
        color: config.colorFons,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: colorVora, width: 3),
      ),
      // RECUPEREM EL GESTURE DETECTOR GLOBAL (Sessió 1B)
      // L'emboliquem aquí perquè detecti qualsevol interacció dins del panell.
      // Encara que avui no l'usem, el necessitarem a la Sessió 1D per detectar
      // el "Swipe" (lliscament) per passar la foto gran cap a la dreta o esquerra.
      child: GestureDetector(
        // Per poder detectar els gestos. De moment no ho farem
        // TODO
        // onHorizontalDragEnd: (details) => funcioPerPassarFoto(),
        // onTapDown: (details) => funcioPerDetectarClicLliure(),

        // Column: Per apilar widgets => zones una sobre l'altre..
        child: Column(
          children: [
            // =========================================================
            // ZONA 1: EL VISOR (Imatge gran)
            // =========================================================
            // Amb el flex: 3, li estem dient que aquesta zona ocuparà
            // 3 quartes parts (75%) de l'alçada total disponible.
            Expanded(
              // Expanded: "Ocupa tot l'espai que sobri de la columna".
              flex:
                  3, // El pes dintre de la columne. flex 3 i flex 1, significa 3/4 (75%)
              child: Container(
                // Container intern per donar marge i un fons fosc a la foto gran
                width: double.infinity, // Ocupa tota l'amplada possible
                margin: const EdgeInsets.all(
                  // Espai exterior (aire al voltant)
                  8,
                ),
                decoration: BoxDecoration(
                  color:
                      Colors.black12, // Fons lleugerament gris per contrastar
                  borderRadius: BorderRadius.circular(10),
                ),

                // Si tenim una foto per mostrar, la pintem. Si no, mostrem un text.
                child: imatgeGran != null
                    // Image.file: Llegeix un fitxer físic del disc dur.
                    // BoxFit.contain: Escala la imatge perquè càpiga sencera sense deformar-se.
                    ? Image.file(File(imatgeGran.path), fit: BoxFit.contain)
                    : const Center(
                        // Center: Centra el text "Carpeta buida..." vertical i horitzontalment.
                        child: Text("Carpeta buida o sense selecció"),
                      ),
              ),
            ),

            // Divider: Dibuixa una línia horitzontal fina per separar les dues zones.
            const Divider(height: 1),

            // =========================================================
            // ZONA 2: LA GALERIA (Miniatures inferiors)
            // =========================================================
            Expanded(
              flex:
                  1, // El pes dintre de la columne. flex 3 i flex 1, significa 1/4 (25%)
              // SingleChildScrollView: per evitar l'error de "Overflow"
              // Permet que el contingut interior es pugui desplaçar (fer scroll) si no hi cap a la pantalla.
              child: SingleChildScrollView(
                scrollDirection: Axis
                    .horizontal, // Fem que l'scroll sigui d'esquerra a dreta (tipus Reel)
                padding: const EdgeInsets.all(8),

                // Row: Organitza les miniatures una al costat de l'altra.
                // A diferència del WRAP, el Row no salta de línia, per això necessita l'ScrollView.
                child: Row(
                  // map(): Transforma la llista de dades (ElementImatge) en una llista de ginys (Widgets).
                  children: imatges.map((img) {
                    // Mirem si l'ID d'aquesta imatge està dins de la llista de seleccionats
                    final isSelected = seleccionats.contains(img.id);

                    // GestureDetector (Local): Aquest és específic de cada miniatura.
                    // És el que tradueix el toc de l'usuari a la lògica (seleccionar)
                    return GestureDetector(
                      onTap: () => onAccio(img.id, TipusAccio.seleccionar),

                      // Container de cada miniatura, per dibuixar la vora blava si està seleccionada
                      child: Container(
                        margin: const EdgeInsets.only(
                          right: 10,
                        ), // Espai entre fotos
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: isSelected
                                ? Colors.blue
                                : Colors.transparent,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),

                        // ClipRRect: "Retalla" les cantonades de la imatge filla perquè no
                        // sobresurti del contenidor arrodonit. (Molt útil per estètica).
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          // BoxFit.cover: Escala la imatge per omplir el quadrat, retallant el que sobri.
                          child: Image.file(
                            File(img.path),
                            width: 70,
                            height: 70,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  }).toList(), // Converteix el resultat del map en una List<Widget>
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
