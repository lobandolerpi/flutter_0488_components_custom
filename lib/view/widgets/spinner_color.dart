import 'package:flutter/material.dart';

class ColorSpinner extends StatelessWidget {
  final String label;
  final int value;
  final ValueChanged<int> onChanged;
  // Afegim el controlador per poder situar l'spinner en el valor inicial
  final FixedExtentScrollController controller;

  const ColorSpinner({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    required this.controller, // Obligatori per la lògica de scroll
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 80, // Una mica més d'alçada per millorar l'UX
          width: 50,
          child: ListWheelScrollView.useDelegate(
            controller: controller, // Connectem el controlador
            itemExtent: 30,
            onSelectedItemChanged: onChanged,
            physics: const FixedExtentScrollPhysics(),
            childDelegate: ListWheelChildBuilderDelegate(
              builder: (context, index) => Center(
                child: Text("$index", style: const TextStyle(fontSize: 14)),
              ),
              childCount: 256,
            ),
          ),
        ),
      ],
    );
  }
}
