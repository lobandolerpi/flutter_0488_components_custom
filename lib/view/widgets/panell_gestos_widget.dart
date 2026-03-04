import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_0488_components_custom/model/galery_data.dart';

// Mètode d'ajuda per crear la miniatura,
// Així no he de picar tot això al Component, i queda més net
Widget _buildMiniatura(ElementImatge img, bool isSelected) {
  return Container(
    margin: const EdgeInsets.all(4),
    decoration: BoxDecoration(
      border: Border.all(
        color: isSelected ? Colors.blue : Colors.transparent,
        width: 2,
      ),
      borderRadius: BorderRadius.circular(8),
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: Image.file(
        File(img.path),
        width: 70,
        height: 70,
        fit: BoxFit.cover,
      ),
    ),
  );
}

//  S1D Això es un Shortcut, Intent és semblant a GestureDetectors però per accions de teclat.
// flutter recomana Intents a tecles específiques. El mateix intent es pot disparar amb Del o Supr
class DeleteIntent extends Intent {
  const DeleteIntent();
}

class DeleteAction extends Action<DeleteIntent> {
  // El callback que volem executar (la funció del ViewModel)
  final VoidCallback onInvokeAction;

  DeleteAction(this.onInvokeAction);

  @override
  void invoke(DeleteIntent intent) {
    // Aquí s'executa la lògica quan es detecta l'intent
    onInvokeAction();
  }
}

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

  final int? imatgeMostradaId;

  // 3. Callbacks per a la gestió d'esdeveniments (RA 3.4)
  final void Function(int, TipusAccio, {bool multiSelect})
  onAccio; // Callback complex
  final VoidCallback onEsborrar; // S1D Nou callback
  final Function(int) onImageDropped;
  final Function(int) onSwipe; // Enviarem -1 (previ) o 1 (següent)

  // AFEGIM AIXÒ: Un controlador per vincular la barra i la llista
  // final ScrollController _controladorScroll = ScrollController();

  // El constructor
  // const PanellInteractiuWidget({  // Ho preferim aixì, pero si necessitem el Scroll Controller no és possible
  // PanellInteractiuWidget({ // Si fem servir ScrollController ha de poder variar.
  const PanellInteractiuWidget({
    super.key, // això és l'identificador únic del giny, fem servir el mètode del pare per crear-lo.
    required this.config, // Es necessari les dades de configuració del widget.
    required this.imatges,
    required this.seleccionats,
    required this.imatgeMostradaId,
    required this.onAccio,
    required this.onEsborrar, // S1D nou callback
    required this.onImageDropped,
    required this.onSwipe,
    this.colorVora = Colors.transparent, // Valor per defecte
    this.alcada = 200.0, // Valor per defecte
  });

  @override
  Widget build(BuildContext context) {
    // Determinar imatge gran basada EXCLUSIVAMENT en imatgeMostradaId
    final ElementImatge? imatgeGran = imatgeMostradaId != null
        ? imatges.firstWhere(
            (img) => img.id == imatgeMostradaId,
            // Fallback per si l'ID esborrat era el mostrat
            orElse: () => imatges.isNotEmpty
                ? imatges.first
                : throw Exception('Llista buida'),
          )
        : (imatges.isNotEmpty ? imatges.first : null);

    // S1D El Widget ara té MOOOOLTES CAPES NIUADES.
    // flutter diu que primer TECLAT i La jerarquia de Teclat (Shortcuts -> Actions -> Focus)
    return Shortcuts(
      // 1. EL DICCIONARI (Mapping Tecla -> Intenció)
      shortcuts: <ShortcutActivator, Intent>{
        LogicalKeySet(
          LogicalKeyboardKey.delete,
        ): const DeleteIntent(), // si ens cliquen delete, el nostre Intent serà DeleteIntent (que l'hen definit.)
      },
      child: Actions(
        // 2. EL DICCIONARI D'ACCIONS (Mapping Intenció -> Classe d'Acció)
        actions: <Type, Action<Intent>>{
          DeleteIntent: DeleteAction(
            onEsborrar,
          ), // Si la intenció és esborrar l'Acció d'esborrar amb el callback del que cal d'esborrar
        },
        // 3a CAPA: Focus (El listener que escolta el teclat)
        child: Focus(
          autofocus: true, // forcem que estigui actiu sempre
          child: AnimatedContainer(
            // A partir d'aquí exactament com era a S1C (si hi ha canvis, s'expliciten)
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

            // @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
            // @@    child: GestureDetector(          @@
            // @@  Atenció: Arena dels gestos, explicar  @@
            // @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
            // Per poder detectar els gestos. De moment no ho farem
            // TODO
            // onHorizontalDragEnd: (details) => funcioPerPassarFoto(),
            // onTapDown: (details) => funcioPerDetectarClicLliure(),

            // Column: Per apilar widgets => zones una sobre l'altre..
            child: Column(
              children: [
                Expanded(
                  // Expanded: "Ocupa tot l'espai que sobri de la columna".
                  flex:
                      3, // El pes dintre de la columna. flex 3 i flex 1, significa 3/4 (75%)
                  child: GestureDetector(
                    // GestureDetector (Local): Aquest és específic de la imatge gran
                    onHorizontalDragEnd: (details) {
                      // Lambda on puc emprar els detalls del Drag per decidir esquerra o dreta
                      // Detectem la direcció del swipe a partir de la velocitat (primaryVelocity)
                      if (details.primaryVelocity! > 0) {
                        // Arrossega cap a la dreta -> Imatge prèvia
                        onSwipe(-1);
                      } else if (details.primaryVelocity! < 0) {
                        // Arrossega cap a l'esquerra -> Imatge següent
                        onSwipe(1);
                      }
                    },
                    child: DragTarget<int>(
                      onAcceptWithDetails: (details) {
                        // 'details.data' conté l'ID (int) de la miniatura que hem arrossegat.
                        // 'details.offset' et donaria les coordenades x,y d'on s'ha deixat anar (opcional, per si ho vols comentar als alumnes).

                        // Quan deixem anar la miniatura a sobre
                        onImageDropped(details.data);
                      },

                      builder: (context, candidateData, rejectedData) {
                        // Si candidateData.isNotEmpty vol dir que tenim un drag a sobre!
                        // candidateData és gestionat internament pel DragTarget. Cap StatefulWidget necessari!
                        final isHovered = candidateData.isNotEmpty;

                        return
                        // =========================================================
                        // ZONA 1: EL VISOR (Imatge gran)
                        // =========================================================
                        // Amb el flex: 3, li estem dient que aquesta zona ocuparà
                        // 3 quartes parts (75%) de l'alçada total disponible.
                        Container(
                          // Container intern per donar marge i un fons fosc a la foto gran
                          width:
                              double.infinity, // Ocupa tota l'amplada possible
                          margin: const EdgeInsets.all(
                            // Espai exterior (aire al voltant)
                            8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors
                                .black12, // Fons lleugerament gris per contrastar
                            borderRadius: BorderRadius.circular(10),
                          ),

                          // Si tenim una foto per mostrar, la pintem. Si no, mostrem un text.
                          child: imatgeGran != null
                              // Image.file: Llegeix un fitxer físic del disc dur.
                              // BoxFit.contain: Escala la imatge perquè càpiga sencera sense deformar-se.
                              ? Image.file(
                                  File(imatgeGran.path),
                                  fit: BoxFit.contain,
                                )
                              : const Center(
                                  // Center: Centra el text "Carpeta buida..." vertical i horitzontalment.
                                  child: Text("Carpeta buida o sense selecció"),
                                ),
                        );
                      },
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

                  // Opció 1
                  /*child: SingleChildScrollView(
               scrollDirection: Axis
                     .horizontal, // Fem que l'scroll sigui d'esquerra a dreta (tipus Reel)
               padding: const EdgeInsets.all(8),
               //  Row: Organitza les miniatures una al costat de l'altra.
               // A diferència del WRAP, el Row no salta de línia, per això necessita l'ScrollView. 
               child: Row(
                // map(): Transforma la llista de dades (ElementImatge) en una llista de ginys (Widgets).
                children: imatges.map((img) { // ... tot igual }
            */

                  // Opció 2: L'opció més responsiva (Graella automàtica)
                  /*child: Padding(
              padding: const EdgeInsets.all(8.0),
              // Wrap: Acomoda els elements un al costat de l'altre.
              // A diferència del Row, quan detecta que no hi caben a la pantalla,
              // salta a la línia següent automàticament. Evita l'error d'"Overflow".
              child: Wrap(
                spacing: 10.0,    // Espai horitzontal entre les fotos
                runSpacing: 10.0, // Espai vertical quan salta a la línia següent
                // map(): Transforma la llista de dades (ElementImatge) en una llista de ginys (Widgets).
                children: imatges.map((img) { // ... tot igual }
            */

                  // Opció 3: Llista amb desplaçament natiu (Tipus Carrusel/Reel)
                  /*child: Scrollbar(
              controller: _controladorScroll,
              thumbVisibility:
                  true, // Força a que la barra es vegi sempre (ideal per a PC)
              // Però entra en conflicte amb
              child: ListView(
                scrollDirection: Axis
                    .horizontal, // Fem que l'scroll sigui d'esquerra a dreta
                padding: const EdgeInsets.all(8.0),
                // ListView: Giny optimitzat per a llistes.
                // A diferència de l'Opció 1, ja porta l'scroll incorporat de sèrie,
                // per tant no necessita cap SingleChildScrollView pare.
                // map(): Transforma la llista de dades (ElementImatge) en una llista de ginys (Widgets).
                children: imatges.map((img) { // ... tot igual }
            */
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    // Wrap: Acomoda els elements un al costat de l'altre.
                    // A diferència del Row, quan detecta que no hi caben a la pantalla,
                    // salta a la línia següent automàticament. Evita l'error d'"Overflow".
                    child: Wrap(
                      spacing: 10.0, // Espai horitzontal entre les fotos
                      runSpacing:
                          10.0, // Espai vertical quan salta a la línia següent
                      // map(): Transforma la llista de dades (ElementImatge) en una llista de ginys (Widgets).
                      children: imatges.map((img) {
                        // Mirem si l'ID d'aquesta imatge està dins de la llista de seleccionats
                        final isSelected = seleccionats.contains(img.id);

                        // GestureDetector (Local): Aquest és específic de cada miniatura.
                        // És el que tradueix el toc de l'usuari a la lògica (seleccionar)
                        return Draggable<int>(
                          data: img
                              .id, // La dada que canvia i s'introdueix a la llista del Draggable.
                          // 1. Com es veu la miniatura mentre vola (Drag)
                          feedback: ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: Image.file(
                              File(img.path),
                              width: 70,
                              height: 70,
                              fit: BoxFit.cover,
                            ),
                          ),

                          // 2. Com es veu el forat que deixa al Wrap
                          childWhenDragging: Opacity(
                            opacity: 0.3,
                            child: _buildMiniatura(img, isSelected),
                          ),

                          // 3. El component en estat normal (Tap per seleccionar)
                          child: GestureDetector(
                            onTap: () {
                              // Recuperem la teva lògica exacta de tecles!
                              final isShiftPressed =
                                  HardwareKeyboard.instance.logicalKeysPressed
                                      .contains(LogicalKeyboardKey.shiftLeft) ||
                                  HardwareKeyboard.instance.logicalKeysPressed
                                      .contains(LogicalKeyboardKey.shiftRight);

                              // Enviem l'acció cap al pare
                              onAccio(
                                img.id,
                                TipusAccio.seleccionar,
                                multiSelect: isShiftPressed,
                              );
                            },
                            // Posem la UI a dins
                            child: _buildMiniatura(img, isSelected),
                          ),
                        );
                      }).toList(), // Converteix el resultat del map en una List<Widget>
                    ),
                  ),
                ),
              ],
            ),
            //), //Gesture Detector (global)
          ),
        ),
      ),
    );
  }
}
