import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_0488_components_custom/model/panell_ui_state_data.dart';
import 'package:provider/provider.dart';
import 'viewmodel/main_viewmodel.dart';
import 'view/main_screen.dart';
import 'package:window_manager/window_manager.dart'; // Per controlar mida mínima de la finestra

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

void main() async {
  // Asincron perquè ara donem ordres al Sistema Operatiu.
  // 1 Obligatori per l'asincronia abans del runApp
  WidgetsFlutterBinding.ensureInitialized();

  // 2 Inicialitzar el Control de finestres d'escriptori
  await windowManager.ensureInitialized();

  // 3 Defineixo les opcions d bàsiques de la finestra.
  // Nota: La logica del tamany i posició
  // la trasllado al callback
  // així m'asseguro que S.O. té registrat el "handle" de la finestra
  WindowOptions windowOptions = const WindowOptions(
    center: true,
    backgroundColor: Colors.transparent,
    skipTaskbar: false,
    title: "Galeria de Fotos interactiva",
  );

  // 4. Inicio el Manager de la finestra ara que ja tinc 'handle´
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    // 4.1. Consulto al S.O. les mides de la pantalla
    // quan el S.O. ja està llest per mostrar la finestra.
    final percentatge = 0.85;
    final display = WidgetsBinding.instance.platformDispatcher.displays.first;
    final screenWidth = display.size.width;
    final screenHeight = display.size.height;
    final posicioX = screenWidth * (1 - percentatge) / 2;
    final posicioY = screenHeight * (1 - percentatge) / 2;

    // 4.2 Aplico les mides explicitant esperant a que el S.O. respongui
    await windowManager.setMinimumSize(const Size(800, 600));
    await windowManager.setSize(
      Size(screenWidth * percentatge, screenHeight * percentatge),
    );

    // 4.3. Li dic explicitament que no maximitzi, pq m'estava mazimitzant
    // a un dels ordinadors.
    await windowManager.unmaximize();

    // 4.4 posiciona la pantalla a l'espai disponible
    await windowManager.setPosition(Offset(posicioX, posicioY));

    // --- Lògica específica per a Linux/Ubuntu ---
    if (Platform.isLinux) {
      await windowManager.show();
      // Ubuntu necessita un petit temps per processar les restriccions de mida
      // un cop la finestra ja és visible.
      await Future.delayed(const Duration(milliseconds: 200));
      await windowManager.setMinimumSize(const Size(800, 600));
    } else {
      await windowManager.show();
    }

    await windowManager.focus();
  });

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MainViewModel(PanellUiState())),
      ],
      child: const App0488(),
    ),
  );
}
