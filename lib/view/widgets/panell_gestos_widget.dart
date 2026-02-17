import 'package:flutter/material.dart';

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

  // 3. Callbacks per a la gestió d'esdeveniments (RA 3.4)

  /// Retorna un text descriptiu del gest
  final Function(String) onAccioDetectada; // Funció que retornarà un string.

  /// Retorna les coordenades exactes del clic (Dada complexa)
  final Function(Offset) onPosicioDetectada;

  /// Callback sense paràmetres (VoidCallback) acabar interacció, que es pot escoltar a diversos llocs
  final VoidCallback? onFiInteraccio;

  // El constructor
  const PanellInteractiuWidget({
    super.key, // això és l'identificador únic del giny, fem servir el mètode del pare per crear-lo.
    required this.config, // Es necessari les dades de configuració del widget.
    required this.onAccioDetectada, // Callback necessari
    required this.onPosicioDetectada, // Callback necessari
    this.onFiInteraccio, // Pot ser null -> No és necessari
    this.colorVora = Colors.transparent, // Valor per defecte
    this.alcada = 200.0, // Valor per defecte
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // PRIMER ELS GESTOS, DEFINEIXEN QUE PASSA QUAN L'USUARI INTERACTUA.
      // --- Gest inicial ---
      onTapDown: (detalls) {
        // quan l'usuari toca la pantalla o clicka "onTapDown"
        // El Framework de Flutter en tems d'execució, detecta l'esdeveniment i empaqueta tota la informació.
        // l'objecte que és de tipus TapDownDetails, i nosaltres li diem "detalls"
        onPosicioDetectada(detalls.localPosition);
        // Quan aixó passa, nosaltres volem executar el mètode onPosicioDetectada
        // que necessita un objecteOffset per saber les coordenades.
        // li passim la part de detalls que són aquestes coordenades.
      },

      // --- Gestos de click (Tap) ---
      onTap: () => onAccioDetectada("Click confirmat"),
      onLongPress: () => onAccioDetectada("Pulsació llarga"),
      // --- Gest secundari (Botó dret) ---
      onSecondaryTap: () => onAccioDetectada("Botó dret"),

      // --- Gestos de moviment (Pan) ---
      onPanUpdate: (detalls) {
        onPosicioDetectada(detalls.localPosition);
        onAccioDetectada("Arrossegant..");
      },

      // --- FI DE LES INTERACCIONS
      // (Executem el 3r Callback) si no es null i a tots els seus posibles desencadenants.
      onTapUp: (detalls) {
        // S'acaba el click
        if (onFiInteraccio != null) onFiInteraccio!();
      },
      onTapCancel: () {
        // Comencem a moure el dit o ratoli.
        if (onFiInteraccio != null) onFiInteraccio!();
      },
      onPanEnd: (_) {
        // S'acaba el Pan
        onAccioDetectada("Fi del moviment");
        if (onFiInteraccio != null) onFiInteraccio!();
      },

      // SEGON EL COMPONENT TAL COM ES DIMUIXA
      child: AnimatedContainer(
        // AnimatedContainer, ens permetrar fer animacions per interaccions en el futur.
        duration: const Duration(
          milliseconds: 300,
        ), // Quant duraran les animacions
        width: double.infinity, // Tota la amplada
        height: alcada, // alçada pot canviar amb estils.
        decoration: BoxDecoration(
          // BoxDecoration per fer visual
          // ATENCIó !!! El color de fons no és estil, és estat del component.
          color: config.colorFons,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: colorVora, width: 3),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 8,
              offset: Offset(2, 4),
            ),
          ],
        ),
        child: Center(
          child: Text(
            // ATENCIó !!! El color de fons no és estil, és estat del component.
            config.titol,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
