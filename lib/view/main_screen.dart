import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/main_viewmodel.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Escoltem el ViewModel
    final vm = context.watch<MainViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text("MVVM Pur (Sessió 00)")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Text de Salutació (El ViewModel decideix si surt text o buit)
            Text(
              vm.greetingText,
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 50),

            // Botó d'Acció
            ElevatedButton(
              onPressed: vm.toggleVisibility,
              child: Text(vm.buttonText), // El text ve del Model via ViewModel
            ),
          ],
        ),
      ),
    );
  }
}
