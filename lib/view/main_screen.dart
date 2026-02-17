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
      appBar: AppBar(title: const Text("Sessió 1B Gestos i Estat UI")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Monitorització del panell:",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),

            // 1. LECTURA DE L'ESTAT: Mostrem el text descriptiu del gest
            Text(
              "Últim gest: ${vm.estatPanell.missatgeGest}",
              style: const TextStyle(fontSize: 18, color: Colors.blueGrey),
            ),
            const SizedBox(height: 5),

            // 2. LECTURA DE L'ESTAT: Mostrem les coordenades locals
            Text(
              "Coordenades: X: ${vm.estatPanell.posX.toInt()}, Y: ${vm.estatPanell.posY.toInt()}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),

            const SizedBox(height: 40),

            // 3. EL NOSTRE WIDGET CUSTOM
            PanellInteractiuWidget(
              // Dades de domini (Estàtiques)
              config: const PanellConfig(
                titol: "WIDGET PANELL: Àrea de Pràctiques 1B",
                colorFons: Color.fromARGB(255, 195, 196, 192),
              ),

              // Paràmetres d'estil (Reacció dinàmica a l'estat)
              colorVora: vm.estatPanell.colorVora,
              alcada: 250,

              // --- GESTIÓ D'ESDEVENIMENTS (Callbacks cap al ViewModel) ---
              onAccioDetectada: (text) {
                vm.actualitzarMissatge(text);
              },

              onPosicioDetectada: (pos) {
                vm.actualitzarCoordenades(pos);
              },

              // S'executarà al onTapUp, onTapCancel i onPanEnd
              onFiInteraccio: () {
                vm.canviarColorAleatori();
              },
            ),

            // 3. EL NOSTRE WIDGET CUSTOM DE VERITAT
            //PanellInteractiuWidget(
            // Dades de domini (Estàtiques)

            // Paràmetres d'estil (Reacció dinàmica a l'estat)

            // --- GESTIÓ D'ESDEVENIMENTS (Callbacks cap al ViewModel) ---

            //),
          ],
        ),
      ),
    );
  }
}
