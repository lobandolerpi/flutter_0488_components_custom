import 'package:flutter/material.dart';
import 'package:flutter_0488_components_custom/view/widgets/spinner_color.dart';

class ConfigColorDialog extends StatefulWidget {
  final Color initialFons;
  final Color initialText;

  const ConfigColorDialog({
    super.key,
    required this.initialFons,
    required this.initialText,
  });

  @override
  State<ConfigColorDialog> createState() => _ConfigColorDialogState();
}

class _ConfigColorDialogState extends State<ConfigColorDialog> {
  late int rf, gf, bf; // ESTATS Red, Green, Blue Fons
  late int rt, gt, bt; // ESTATS Red, Green, Blue Text

  @override
  void initState() {
    super.initState();
    rf = widget.initialFons.r.toInt();
    // Nota: Flutter 3.22+ fa servir .r, .g, .b (0.0 a 1.0)
    gf = widget.initialFons.g.toInt();
    // O .red, .green, .blue (0 a 255) segons versió.
    bf = widget.initialFons.b.toInt();
    rt = widget.initialText.r.toInt();
    gt = widget.initialText.g.toInt();
    bt = widget.initialText.b.toInt();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Configuració de Colors"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("Color de Fons (RGB)"),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            // Cada vegada que es mou l’Spinner (onChanged)
            // actualitzem l’estat amb setState
            // Flutter torna a executar el mètode build del diàleg.
            children: [
              ColorSpinner(
                label: "R",
                value: rf,
                onChanged: (v) => setState(() => rf = v),
              ), // , color: Colors.red
              ColorSpinner(
                label: "G",
                value: gf,
                onChanged: (v) => setState(() => gf = v),
              ),
              ColorSpinner(
                label: "B",
                value: bf,
                onChanged: (v) => setState(() => bf = v),
              ),
            ],
          ),
          const Divider(),
          const Text("Color de Text (RGB)"),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ColorSpinner(
                label: "R",
                value: rt,
                onChanged: (v) => setState(() => rt = v),
              ),
              ColorSpinner(
                label: "G",
                value: gt,
                onChanged: (v) => setState(() => gt = v),
              ),
              ColorSpinner(
                label: "B",
                value: bt,
                onChanged: (v) => setState(() => bt = v),
              ),
            ],
          ),
        ],
      ),

      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel·lar"),
        ),
        ElevatedButton(
          onPressed: () {
            final fons = Color.fromARGB(255, rf, gf, bf);
            final text = Color.fromARGB(255, rt, gt, bt);
            Navigator.pop(context, {'fons': fons, 'text': text});
          },
          // El diàleg no coneix el ViewModel
          // (per mantenir el desacoblament).
          // El diàleg simplement "retorna"
          // un paquet de dades a qui l'ha cridat.
          child: const Text("Aplicar"),
        ),
      ],
    );
  }
}
