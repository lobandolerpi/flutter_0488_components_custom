import 'dart:io';
import 'package:flutter/material.dart';
import '../../model/galery_data.dart';
import 'package:flutter/foundation.dart'
    show kIsWeb; // Per detectar si la app s'està corrents en web

// Variables temporals fora de la classe per respectar la immutabilitat del StatelessWidget
double _startX = 0;
double _startY = 0;

class VisorImatgeWidget extends StatelessWidget {
  final ElementImatge? imatgeGran;
  final Color colorVora;

  // Callbacks directes arquitectura perfecta.
  final Function(int) onSwipe;
  final Function(int) onImageDropped;
  final Function(double, double)? onMarcadorPosat; // Nou de la sessió 1F

  const VisorImatgeWidget({
    super.key,
    required this.imatgeGran,
    required this.colorVora,
    required this.onSwipe,
    required this.onImageDropped,
    this.onMarcadorPosat,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDesktop =
        !kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS);

    // 1. COMENCEM PEL GESTURE DETECTOR PER ALS SWIPES (Direccions)
    // Ara és evident que és local de la imatge gran.
    //   Fa que TOTA la capsa (inclòs l'espai buit si se li fa Expanded) sigui tàctil
    return GestureDetector(
      behavior: HitTestBehavior.opaque,

      // -- INICI CODI ORIGINAL SESSIONS 1D/1E (Swipe) --
      onHorizontalDragStart: (isDesktop || kIsWeb)
          ? (details) {
              // Si som a escriptori o a web millor onHorizontalDragUpdate
              _startX = details.globalPosition.dx;
              _startY = details.globalPosition.dy;
            }
          : null, // Si no som a escriptori ni movil això no s'executa.

      onHorizontalDragEnd: (isDesktop || kIsWeb)
          ? (details) {
              // Si som a escriptori o a web aquesta s'executa aquesta versió
              double actualX = details.globalPosition.dx;
              double actualY = details.globalPosition.dy;
              double diferenciaX = actualX - _startX;
              double diferenciaY = actualY - _startY;
              if (diferenciaX.abs() >
                      50 // Només si el gest és més de 50 pixels horitzontal
                      &&
                  diferenciaX.abs() >
                      2 *
                          diferenciaY
                              .abs() // clarament horitzontal comparat amb el vertical
                              ) {
                if (diferenciaX > 0) {
                  // Moviment positiu (d'esquerra a dreta) -> Imatge prèvia
                  onSwipe(-1);
                } else {
                  // Moviment negatiu (de dreta a esquerra) -> Imatge següent
                  onSwipe(1);
                }
              }
            }
          : (details) {
              // en qualsevol altre cas són a mòbil i el onHorizontalDragEnd va genial
              // GUARDRAIL: Evitem que l'app peti si la velocitat és null
              final velocitat = details.primaryVelocity;

              // Si la velocitat és null o 0, ignorem el gest perquè no ha estat un "swipe" net
              if (velocitat == null || velocitat == 0) return;
              // Detectem la direcció del swipe a partir de la velocitat (primaryVelocity)
              if (velocitat > 0) {
                // Arrossega cap a la dreta -> Imatge prèvia
                onSwipe(-1);
              } else if (velocitat < 0) {
                // Arrossega cap a l'esquerra -> Imatge següent
                onSwipe(1);
              }
            },

      child: DragTarget<int>(
        // 'details.data' conté l'ID (int) de la miniatura que hem arrossegat.
        // 'details.offset' et donaria les coordenades x,y d'on s'ha deixat anar (opcional, per si ho vols comentar als alumnes).
        onAcceptWithDetails: (details) {
          // Quan deixem anar la miniatura a sobre
          onImageDropped(details.data);
        },
        builder: (context, candidateData, rejectedData) {
          // Si candidateData.isNotEmpty vol dir que tenim un drag a sobre!
          // candidateData és gestionat internament pel DragTarget. Cap StatefulWidget necessari!
          final isDragHovered = candidateData.isNotEmpty;

          return AnimatedContainer(
            // =========================================================
            // ZONA 1: EL VISOR (Imatge gran)
            // =========================================================
            // Amb el flex: 3, li estem dient que aquesta zona ocuparà
            // 3 quartes parts (75%) de l'alçada total disponible.
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            // Canviem l'aspecte del contenidor de la imatge gran quan hi ha un drop a sobre
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                // Si hi tenim la imatge a sobre, la vora es posa verda i més gruixuda
                color: isDragHovered ? Colors.greenAccent : colorVora,
                width: isDragHovered ? 4.0 : 2.0,
              ),
              boxShadow: isDragHovered
                  ? [
                      BoxShadow(
                        color: Colors.greenAccent.withValues(alpha: .4),
                        blurRadius: 15,
                        spreadRadius: 2,
                      ),
                    ]
                  : [],
            ),
            // Per fer-ho encara més evident, podem posar un filtre de color a la imatge gran
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(
                isDragHovered
                    ? Colors.white.withValues(alpha: 0.3)
                    : Colors.transparent,
                BlendMode.lighten,
              ),
              child: imatgeGran != null
                  ? Image.file(File(imatgeGran!.path), fit: BoxFit.cover)
                  : const Center(child: Text("Cap imatge")),
            ),
          );
        },
      ),
    );
  }
}
