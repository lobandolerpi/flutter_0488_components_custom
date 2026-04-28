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
    // Creem els objectes color aquí mateix per netejar el codi de sota
    final actualFons = Color.fromARGB(255, rf, gf, bf);
    final actualText = Color.fromARGB(255, rt, gt, bt);

    return AlertDialog(
      title: const Text("Configurar Colors RGB"),
      content: SingleChildScrollView(
        child: Column(
          children: [
            // --- SECCIÓ PREVIEW (Molt més visual per l'alumne) ---
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 60,
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: actualFons,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade400),
              ),
              child: Center(
                child: Text(
                  "Així es veurà el text",
                  style: TextStyle(
                    color: actualText,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const Text(
              "Colors del Fons",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ColorSpinner(
                  label: "R",
                  value: rf,
                  controller: ctrlRF,
                  onChanged: (v) => setState(() => rf = v),
                ), // ARA SÍ!
                ColorSpinner(
                  label: "G",
                  value: gf,
                  controller: ctrlGF,
                  onChanged: (v) => setState(() => gf = v),
                ),
                ColorSpinner(
                  label: "B",
                  value: bf,
                  controller: ctrlBF,
                  onChanged: (v) => setState(() => bf = v),
                ),
              ],
            ),

            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Divider(),
            ),

            const Text(
              "Colors del Text",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ColorSpinner(
                  label: "R",
                  value: rt,
                  controller: ctrlRT,
                  onChanged: (v) => setState(() => rt = v),
                ),
                ColorSpinner(
                  label: "G",
                  value: gt,
                  controller: ctrlGT,
                  onChanged: (v) => setState(() => gt = v),
                ),
                ColorSpinner(
                  label: "B",
                  value: bt,
                  controller: ctrlBT,
                  onChanged: (v) => setState(() => bt = v),
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
            // Passem el resultat final al ViewModel via la Screen
            Navigator.pop(context, {'fons': actualFons, 'text': actualText});
          },
          child: const Text("Aplicar i Desar"),
        ),
      ],
    );
  }
}
