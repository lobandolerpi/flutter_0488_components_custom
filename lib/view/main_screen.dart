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
      // Aqui hi haurà overflow
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Panell amb 2 zones, miniatures i imatge:",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),

            // 3. EL NOSTRE WIDGET CUSTOM
            PanellInteractiuWidget(
              // Dades de domini (Estàtiques)
              config: const PanellConfig(
                titol: "WIDGET PANELL FOTOS: Àrea de Pràctiques 1C",
                colorFons: Color.fromARGB(255, 195, 196, 192),
              ),

              // Paràmetres d'estil (Reacció dinàmica a l'estat)
              colorVora: vm.estatPanell.colorVora,
              alcada: 700,
              imatges: vm.estatPanell.llistaImatges,
              seleccionats: vm.estatPanell.seleccionats,

              // --- GESTIÓ D'ESDEVENIMENTS (Callbacks cap al ViewModel) ---
              onAccio: (id, accio) => vm.gestionarSeleccio(id, accio),
            ),

            // Afegiu un botó a sota per disparar la lectura inicial:
            ElevatedButton.icon(
              onPressed: () => vm.carregarImatgesDirectori("./data/imatges"),
              icon: const Icon(Icons.refresh),
              label: const Text("Escanejar carpeta data/fotos"),
            ),
          ],
        ),
      ),
    );
  }
}
