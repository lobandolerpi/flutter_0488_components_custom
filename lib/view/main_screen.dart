import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/main_viewmodel.dart';
import '../view/widgets/panell_gestos_widget.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Escoltem el ViewModel
    final vm = context.watch<MainViewModel>();

    return Scaffold(
      // Opció 1
      /*body: SingleChildScrollView( // <--- Afegeix això
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [*/

      // Opció 2
      // Aqui hi haurà overflow
      /*body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [ */

      //
      body: SafeArea(
        // Evita solapar barres de sistema
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                "App widgets personalitzats (Imatges+Minis/ botons càrrega):",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              // 1. EL NOSTRE WIDGET CUSTOM
              Expanded(
                // Ocupa tot l'espai disponible (menys els 100 pixels fixes dels botons)
                child: PanellInteractiuWidget(
                  // Dades de domini (Estàtiques)
                  config: const PanellConfig(
                    titol: "WIDGET PANELL FOTOS: Àrea de Pràctiques 1C",
                    colorFons: Color.fromARGB(255, 195, 196, 192),
                  ),

                  // Paràmetres d'estil (Reacció dinàmica a l'estat)
                  colorVora: vm.estatPanell.colorVora,
                  //alcada: 420,
                  imatges: vm.estatPanell.llistaImatges,
                  seleccionats: vm.estatPanell.seleccionats,

                  imatgeMostradaId: vm.estatPanell.imatgeMostradaId,

                  // --- GESTIÓ D'ESDEVENIMENTS (Callbacks cap al ViewModel) ---
                  onAccio: (id, accio, {multiSelect = false}) =>
                      vm.gestionarSeleccio(id, accio, multiSelect: multiSelect),
                  onEsborrar: () => vm.eliminarSeleccionats(),
                  onImageDropped: (id) => vm.canviarImatgeMostrada(id),
                  onSwipe: (direccio) => vm.navegarImatge(direccio),
                  onReorder: (oldIdx, newIdx) =>
                      vm.reordenarFotos(oldIdx, newIdx),
                  // // // ALERTA // COMPROVAR

                  // NOU S1F: Injectem l'estat de les coordenades del ViewModel
                  marcadorX: vm.estatPanell.posX,
                  marcadorY: vm.estatPanell.posY,
                  onMarcadorPosat: (x, y) {
                    // Quan el Panell ens avisa, ho passem al ViewModel perquè recalculi
                    vm.actualitzarMarcador(x, y);
                  },
                ),
              ),

              const SizedBox(
                height: 16,
              ), // Una mica d'aire respecte al panell interactiu
              // --- PANELL DE CONTROL INFERIOR --
              SizedBox(
                height: 80, // Alçada fixa
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // COLUMNA 1: Feedback Visual Animats
                    Expanded(
                      flex: 1, // Es reparteixen l'espai a parts iguals (1/3)
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.blueGrey.shade800, // Color de fons
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 4,
                              offset: Offset(2, 2),
                            ),
                          ],
                        ),
                        child: const Text(
                          "Estat:\n Esperant acció...",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white, // Color de la lletra
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                // Ombra de les lletres
                                offset: Offset(1.5, 1.5),
                                blurRadius: 3.0,
                                color: Colors.black87,
                              ),
                            ],
                          ), //RextStyle
                        ), //Text
                      ), //AnimatedContainer
                    ), // Expanded

                    const SizedBox(width: 12), // Espaiament horitzontal
                    // COLUMNA 2: Botons de gestió de carpetes
                    Expanded(
                      flex: 1,
                      // SingleChildScrollView evita l'overflow vertical si els botons no hi caben
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            ElevatedButton.icon(
                              // Conservem la funcionalitat que ja tenies!
                              onPressed: () =>
                                  vm.carregarImatgesDirectori("./data/imatges"),
                              icon: const Icon(Icons.refresh),
                              label: const Text("Carregar fotos per defecte"),
                            ),
                            const SizedBox(height: 8),
                            ElevatedButton.icon(
                              onPressed: () {
                                // TODO: Lògica per obrir el File Picker
                              },
                              icon: const Icon(Icons.folder_open),
                              label: const Text("Triar Ruta .exe"),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(width: 12), // Espaiament horitzontal
                    // COLUMNA 3: Botons d'accions de la sessió 1G
                    Expanded(
                      flex: 1,
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () {
                                // TODO: Lògica Sessió 1G
                              },
                              icon: const Icon(Icons.build),
                              label: const Text("Generar Executable"),
                            ),
                            const SizedBox(height: 8),
                            ElevatedButton.icon(
                              onPressed: () {
                                // TODO: Lògica extra / validació
                              },
                              icon: const Icon(Icons.settings),
                              label: const Text("Opcions extra"),
                            ),
                          ], // children Column
                        ), //Column
                      ), // SingleChildScrollView
                    ), //Expanded
                  ], // Children Row
                ), // Row
              ), //SizedBox
            ], // children Column
          ), // Column
        ), // Padding
      ), // Safe area
    ); // Scaffold
  }
}
