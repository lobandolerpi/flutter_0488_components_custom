import 'package:flutter/material.dart';
import 'package:flutter_0488_components_custom/view/widgets/config_color_dialog.dart';
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
                height: 100, // Alçada fixa
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // COLUMNA 1: Feedback Visual Animats
                    Expanded(
                      flex: 2, // Es reparteixen l'espai a proporcions (2/1/1/1)
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: vm.estatPanell.colorInfoFons, // Color de fons
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: vm.estatPanell.colorInfoFons,
                              blurRadius: 4,
                              offset: Offset(2, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          "Darrera ruta desada :\n ${vm.estatPanell.rutaDades}",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: vm
                                .estatPanell
                                .colorInfoText, // Color de la lletra
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                // Ombra de les lletres
                                offset: Offset(1.5, 1.5),
                                blurRadius: 3.0,
                                color: Colors.black54,
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
                              icon: const Icon(Icons.add_a_photo_outlined),
                              label: const Text("Carrega fotos defecte"),
                            ),
                            const SizedBox(height: 8),
                            ElevatedButton.icon(
                              onPressed: () {
                                vm.triarCarpetaICarregar();
                              },
                              icon: const Icon(Icons.folder_open),
                              label: const Text("Triar Ruta fotos"),
                            ),
                          ],
                        ),
                      ),
                    ),
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
                              onPressed: () => vm.carregarImatgesDirectori(
                                vm.estatPanell.rutaDades,
                              ),
                              icon: const Icon(Icons.add_a_photo),
                              label: const Text("Carregar darreres fotos"),
                            ),
                            const SizedBox(height: 8),
                            ElevatedButton.icon(
                              onPressed: () {
                                //
                              },
                              icon: const Icon(Icons.android),
                              label: const Text("Expai lliure"),
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
                                vm.desarConfiguracioTxt();
                              },
                              icon: const Icon(Icons.settings),
                              label: const Text("Desar Config."),
                            ),
                            const SizedBox(height: 8),
                            ElevatedButton.icon(
                              onPressed: () async {
                                final result =
                                    await showDialog<Map<String, Color>>(
                                      context: context,
                                      builder: (context) => ConfigColorDialog(
                                        initialFons:
                                            vm.estatPanell.colorInfoFons,
                                        initialText:
                                            vm.estatPanell.colorInfoText,
                                      ),
                                    );

                                if (result != null) {
                                  vm.actualitzarConfiguracioColors(
                                    result['fons']!,
                                    result['text']!,
                                  );
                                }
                              },
                              icon: const Icon(Icons.palette),
                              label: const Text("Canviar Colors"),
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
