import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_0488_components_custom/view/widgets/visor_imatge_widget.dart';
import '../../model/galery_data.dart';

import 'package:flutter/foundation.dart' show kIsWeb;
import '../../view/widgets/miniatura_widget.dart'; // Per detectar si la app s'està corrents en web

// S1F, he fet una classe en lloc d'un mètode, perquè és molt millor en temes de rendiment
//    i encapsulació.

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

  // NOU S1F: Dades vives (Estat de coordenades)
  final double marcadorX;
  final double marcadorY;

  // 3. Callbacks per a la gestió d'esdeveniments (RA 3.4)
  final void Function(int, TipusAccio, {bool multiSelect})
  onAccio; // Callback complex
  final VoidCallback onEsborrar; // S1D Nou callback
  final Function(int) onImageDropped;
  final Function(int) onSwipe; // Enviarem -1 (previ) o 1 (següent)
  final Function(int oldIndex, int newIndex)? onReorder;

  // NOU S1F: El telèfon per avisar d'un clic a la imatge
  final Function(double, double)? onMarcadorPosat;

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
    required this.onReorder,
    // NOU S1F: Demanem les variables per constructor
    required this.marcadorX,
    required this.marcadorY,
    this.onMarcadorPosat,
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

    // DETECTO SI ESTIC A ESCRIPTORI
    final bool isDesktop =
        !kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS);

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

            // Column: Per apilar widgets => zones una sobre l'altre..
            child: Column(
              children: [
                Expanded(
                  // Expanded: "Ocupa tot l'espai que sobri de la columna".
                  flex:
                      3, // El pes dintre de la columna. flex 3 i flex 1, significa 3/4 (75%)
                  // //////////////////////////////////////////////
                  // CLASSE IMATGE GRAN ENCAPSULADA              //
                  // //////////////////////////////////////////////
                  child: VisorImatgeWidget(
                    imatgeGran: imatgeGran,
                    colorVora: colorVora,
                    onSwipe: onSwipe,
                    onImageDropped: onImageDropped,

                    // NOU S1F: Passem les coordenades de l'estat (config)
                    marcadorX:
                        marcadorX, // O agafa-ho directe del ViewModel si ho tens al PanellInteractiuWidget
                    marcadorY: marcadorY,
                    // NOU S1F: Connectem el callback amb l'exterior (Panell -> Screen -> ViewModel)
                    onMarcadorPosat: onMarcadorPosat,
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
                        int currentIndex = imatges.indexOf(img);

                        // GestureDetector (Local): Aquest és específic de cada miniatura.
                        // És el que tradueix el toc de l'usuari a la lògica (seleccionar)
                        return DragTarget<int>(
                          // Acceptem rebre dades si l'ID arrossegat no és el de la imatge actual
                          onWillAcceptWithDetails: (details) =>
                              details.data != img.id,

                          onAcceptWithDetails: (details) {
                            if (onReorder != null) {
                              // Busquem l'índex antic a partir de l'ID que hem arrossegat
                              int oldIndex = imatges.indexWhere(
                                (element) => element.id == details.data,
                              );
                              if (oldIndex != -1) {
                                onReorder!(oldIndex, currentIndex);
                              }
                            }
                          },
                          builder: (context, candidateData, rejectedData) {
                            // Aprofitem candidateData per fer feedback visual de reordenació
                            bool isBeingTargeted = candidateData.isNotEmpty;

                            // Aquí dins hi va el teu MiniaturaWidget() o el Draggable que ja tenies.
                            // Pots passar-li el isBeingTargeted al MiniaturaWidget per posar-li una
                            // vora verda o fer que es faci una mica més petit quan té una imatge a sobre.
                            return Container(
                              decoration: BoxDecoration(
                                border: isBeingTargeted
                                    ? Border.all(color: Colors.green, width: 3)
                                    : null,
                              ),
                              child: Draggable<int>(
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
                                  // //////////////////////////////////////////////
                                  // CLASSE MINIATURAWIDGET ENCAPSULADA          //
                                  // //////////////////////////////////////////////
                                  child: MiniaturaWidget(
                                    img: img,
                                    isSelected: isSelected,
                                  ),
                                ),

                                // 3. El component en estat normal (Tap per seleccionar)
                                child: GestureDetector(
                                  onTap: () {
                                    // Recuperem la teva lògica exacta de tecles!
                                    final isShiftPressed =
                                        HardwareKeyboard
                                            .instance
                                            .logicalKeysPressed
                                            .contains(
                                              LogicalKeyboardKey.shiftLeft,
                                            ) ||
                                        HardwareKeyboard
                                            .instance
                                            .logicalKeysPressed
                                            .contains(
                                              LogicalKeyboardKey.shiftRight,
                                            );

                                    // Enviem l'acció cap al pare
                                    onAccio(
                                      img.id,
                                      TipusAccio.seleccionar,
                                      multiSelect: isShiftPressed,
                                    );
                                  },
                                  // Posem la UI a dins
                                  // //////////////////////////////////////////////
                                  // CLASSE MINIATURAWIDGET ENCAPSULADA          //
                                  // //////////////////////////////////////////////
                                  child: MiniaturaWidget(
                                    img: img,
                                    isSelected: isSelected,
                                  ),
                                ),
                              ),
                            );
                          },
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
