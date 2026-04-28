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
  // 1. Valors d'estat local (esborrany)
  late int rf, gf, bf, rt, gt, bt;

  // 2. Controladors per als 6 Spinners (perquè apuntin al valor actual)
  late FixedExtentScrollController ctrlRF,
      ctrlGF,
      ctrlBF,
      ctrlRT,
      ctrlGT,
      ctrlBT;

  @override
  void initState() {
    super.initState();
    // Inicialitzem valors des del color rebut
    rf = widget.initialFons.red;
    gf = widget.initialFons.green;
    bf = widget.initialFons.blue;
    rt = widget.initialText.red;
    gt = widget.initialText.green;
    bt = widget.initialText.blue;

    // Inicialitzem els controladors amb la posició correcta
    ctrlRF = FixedExtentScrollController(initialItem: rf);
    ctrlGF = FixedExtentScrollController(initialItem: gf);
    ctrlBF = FixedExtentScrollController(initialItem: bf);
    ctrlRT = FixedExtentScrollController(initialItem: rt);
    ctrlGT = FixedExtentScrollController(initialItem: gt);
    ctrlBT = FixedExtentScrollController(initialItem: bt);
  }

  @override
  void dispose() {
    // Bona pràctica: Alliberar memòria
    for (var c in [ctrlRF, ctrlGF, ctrlBF, ctrlRT, ctrlGT, ctrlBT]) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Configurar Colors RGB"),
      content: SingleChildScrollView(
        child: Column(
          children: [
            const Text(
              "Fons de la zona de text",
              style: TextStyle(color: Colors.blueGrey),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ColorSpinner(
                  label: "R",
                  value: rf,
                  controller: ctrlRF,
                  onChanged: (v) => rf = v,
                ),
                ColorSpinner(
                  label: "G",
                  value: gf,
                  controller: ctrlGF,
                  onChanged: (v) => gf = v,
                ),
                ColorSpinner(
                  label: "B",
                  value: bf,
                  controller: ctrlBF,
                  onChanged: (v) => bf = v,
                ),
              ],
            ),
            const Divider(),
            const Text(
              "Color del text",
              style: TextStyle(color: Colors.blueGrey),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ColorSpinner(
                  label: "R",
                  value: rt,
                  controller: ctrlRT,
                  onChanged: (v) => rt = v,
                ),
                ColorSpinner(
                  label: "G",
                  value: gt,
                  controller: ctrlGT,
                  onChanged: (v) => gt = v,
                ),
                ColorSpinner(
                  label: "B",
                  value: bt,
                  controller: ctrlBT,
                  onChanged: (v) => bt = v,
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel·lar"),
        ),
        ElevatedButton(
          onPressed: () {
            // Retornem els dos nous colors creats des del diàleg
            Navigator.pop(context, {
              'fons': Color.fromARGB(255, rf, gf, bf),
              'text': Color.fromARGB(255, rt, gt, bt),
            });
          },
          child: const Text("Aplicar i Desar"),
        ),
      ],
    );
  }
}
