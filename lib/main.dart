import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'viewmodel/main_viewmodel.dart';
import 'view/main_screen.dart';

void main() {
  runApp(const App0488());
}

class App0488 extends StatelessWidget {
  const App0488({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ChangeNotifierProvider(
        // Creem la instància única del ViewModel.
        create: (_) => MainViewModel(),
        child: const MainScreen(),
      ),
    );
  }
}
