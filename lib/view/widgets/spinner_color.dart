import 'package:flutter/material.dart';

class ColorSpinner extends StatelessWidget {
  final String label;
  final int value;
  final ValueChanged<int> onChanged;

  const ColorSpinner({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 12)),
        SizedBox(
          height: 60,
          width: 50,
          child: ListWheelScrollView.useDelegate(
            itemExtent: 30,
            onSelectedItemChanged: (index) => onChanged(index),
            physics: const FixedExtentScrollPhysics(),
            childDelegate: ListWheelChildBuilderDelegate(
              builder: (context, index) => Center(child: Text("$index")),
              childCount: 256,
            ),
          ),
        ),
      ],
    );
  }
}
