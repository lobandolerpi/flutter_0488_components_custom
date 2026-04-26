import 'package:flutter/material.dart';
import 'package:flutter_0488_components_custom/model/panell_ui_state_data.dart';
import 'package:provider/provider.dart';
import 'viewmodel/main_viewmodel.dart';
import 'view/main_screen.dart';
import 'package:window_manager/window_manager.dart'; // Per controlar mida mínima de la finestra

void main() async {
  // Asincron perquè ara donem ordres al Sistema Operatiu.
  // 1 Obligatori per l'asincronia abans del runApp
  WidgetsFlutterBinding.ensureInitialized();

  // 2 Inicialitzar el Control de finestres d'escriptori
  await windowManager.ensureInitialized();

  // 3 Pregunto al S.O. quina resolució té la seva pantalla principal
  final display = WidgetsBinding.instance.platformDispatcher.displays.first;
  final screenWidth = display.size.width;
  final screenHeight = display.size.height;
  final double windowWidth = 0.85 * screenWidth;
  final double windowHeight = 0.85 * screenHeight;

  // 4 Defineixo les opcions de la finestra.
  WindowOptions windowOptions = WindowOptions(
    size: Size(windowWidth, windowHeight), // Mina inicial
    minimumSize: const Size(800, 600), // Mida mínima
    backgroundColor: Colors.transparent,
    title: "Galeria de Fotos interactiva",
  );

  // 5. Apliquem les opcions i mostrem la finestra
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.setPosition(const Offset(50, 50));
    await windowManager.show();
    await windowManager.focus(); // Porta la finestra al primer pla
  });

  // 6. Arrenquem l'App
  runApp(
    MultiProvider(
      // Això fa més facil escalar la App amb diferents ViewModels
      providers: [
        ChangeNotifierProvider(create: (_) => MainViewModel(PanellUiState())),
      ],
      child: const App0488(),
    ),
  );
}

class App0488 extends StatelessWidget {
  const App0488({super.key});

  /// Funció de factoria per crear el ViewModel.
  MainViewModel createViewModel(BuildContext context) {
    // 1. Instanciem el model (Dades pures)
    final dadesPanell = const PanellUiState();
    // 2. Instanciem el ViewModel injectant-li el model (Desacoblament)
    final viewModel = MainViewModel(dadesPanell);
    return viewModel;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ChangeNotifierProvider(
        // Passem la referència de la funció en lloc d'una lambda
        create: createViewModel,
        child: const MainScreen(),
      ),
    );
  }
}
