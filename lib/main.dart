import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'viewmodel/main_viewmodel.dart';
import 'view/main_screen.dart';
import '../model/greeting_data.dart';

void main() {
  runApp(const App0488());
}

class App0488 extends StatelessWidget {
  const App0488({super.key});

  /// Funció de factoria per crear el ViewModel.
  MainViewModel createViewModel(BuildContext context) {
    // 1. Instanciem el model (Dades pures)
    final dades = GreetingData();
    // 2. Instanciem el ViewModel injectant-li el model (Desacoblament)
    final viewModel = MainViewModel(dades);
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
