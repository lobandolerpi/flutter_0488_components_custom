import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
// Importem els nostres fitxers del projecte
import 'package:flutter_0488_components_custom/model/galery_data.dart';
import 'package:flutter_0488_components_custom/model/panell_ui_state_data.dart';
import 'package:flutter_0488_components_custom/viewmodel/main_viewmodel.dart';

void main() {
  // group() agrupa proves semblants
  group(
    'Proves de la Llista de Fotos', // param1: títol grup
    () {
      // param2: funció anònima amb els TESTS
      test(
        // TEST 1   test() és la prova real
        'Test 1 Navegar cap endavant funciona bé', // param1: títol test
        () {
          // param2: funció anònima amb les INSTRUCCIONS
          // 1. ARRANGE: Preparem les dades
          final llistaProva = [
            const ElementImatge(id: 1, titol: "Foto 1", path: "aaa"),
            const ElementImatge(id: 2, titol: "Foto 2", path: "bbb"),
          ];
          final estatInicial = PanellUiState(
            llistaImatges: llistaProva,
            imatgeMostradaId: 1,
          );
          final vm = MainViewModel(estatInicial);

          // 2. ACT. Actuem(Fem l'acció que volem provar)
          vm.navegarImatge(1); // Passem a la foto 2
          vm.navegarImatge(1); // Intentem passar a una foto 3 que no existeix!
          // com varem fer el codi en carrusel, ha de passar a ser la foto amb codi 1.

          // 3. ASSERT. COMPROVEM El expect jutja si està bé
          // Li diem: "Espero que la imatge mostrada sigui la número 1"
          expect(
            vm.estatPanell.imatgeMostradaId, // param1, valor calculat
            1, // param2, valor esperat
            reason:
                "S'esperava un comportament circular de la llista, \n del final torno al principi i viceversa",
          );
        }, // fi funcio anonima test1
      ); // fi test1
      test(
        // TEST 2   test() és la prova real
        'Test 2 ReordenarFotos altera correctament l\'ordre ', // p1 titol
        () {
          // p2 funcio anonima del test
          final llistaPerTest2 = [
            const ElementImatge(id: 1, titol: "A", path: "aaa"),
            const ElementImatge(id: 2, titol: "B", path: "bbb"),
            const ElementImatge(id: 3, titol: "C", path: "ccc"),
          ];
          final lastInd = llistaPerTest2.length - 1;
          final estatInicial = PanellUiState(llistaImatges: llistaPerTest2);
          final vm = MainViewModel(estatInicial);

          // 2. Act
          // Movem l'element A (index 0) a la posició C (index 2)
          // Atenció amb la lògica d'índexs del reorderable!
          vm.reordenarFotos(0, lastInd);

          // 3. Assert
          // Comprovem que el primer element ara és el B (ID 2)
          expect(
            vm.estatPanell.llistaImatges[0].id,
            2,
            reason:
                "Espero que si moc el primer al final, el primer sigui el 2",
          );
          // Comprovem que l'últim element és l'A (ID 1)
          expect(
            vm.estatPanell.llistaImatges[lastInd].id,
            1,
            reason:
                "Espero que si moc el primer al final, el darrer sigui el 1",
          );
        }, // fi funcio anonima test1
      ); // fi test2
      test(
        "Test 3, excepció out of bounds", // p1 titol
        () {
          // p2 funcio anònima
          // 1. Arrange
          final llistaPerTest3 = [
            const ElementImatge(id: 1, titol: "A", path: "aaa"),
            const ElementImatge(id: 2, titol: "B", path: "bbb"),
            const ElementImatge(id: 3, titol: "C", path: "ccc"),
          ];
          final indexOutOfBounds = llistaPerTest3.length + 1;
          final estatInicial = PanellUiState(llistaImatges: llistaPerTest3);
          final vm = MainViewModel(estatInicial);
          // 2 i 3 Act i Assert són simultanis per les excepcions (funció anónima)
          expect(
            () {
              //param 1 de expect funció anónima
              vm.reordenarFotos(0, indexOutOfBounds);
            },
            throwsA(isA<RangeError>()), // param2 la excepció específica de rang
            reason: "Esperava una excepció RangeError d'index fora de rang",
          );
        },
      );
      test(
        "Test 4, temps d'execució", // p1 titol
        () async {
          // <--- ATENCIÓ: Aquest 'async' és obligatori per l'else!
          // p2 funcio anònima
          // 1 Arrange

          int resultatMatematic = 0;
          var isSincron = true;

          // 2. Act, què passa si fem els càlculs síncrons o asíncrons.
          if (isSincron) {
            sleep(const Duration(seconds: 3));
            // ATENCIÓ: Això és un sleep SÍNCRON.
            // Bloqueja completament el fil d'execució durant 3 segons.
            // Per tant, el processador no pot comprovar si ha passat 1 segon
            // Quan va a comprovar-ho al cap de 3 segons, ja ha passat el test.
            resultatMatematic = 2 + 2;
          } else {
            // Future.delayed allibera el fil principal mentre espera!
            // Això permet que el cronòmetre del Timeout continuï vigilant
            // i pugui aturar l'execució quan toqui.
            await Future.delayed(const Duration(seconds: 3));
            resultatMatematic = 2 + 2;
          }
          // 3. Assert
          expect(
            resultatMatematic,
            4,
            reason:
                "La matemàtica és correcta, però el test no arribarà a temps per comprovar-ho.",
          );
        },
        // CONFIGURACIÓ DEL TIMEOUT:
        // Li diem al test runner: "Si aquest test triga més d'1 segon, mata'l i marca'l com a fallat".
        timeout: const Timeout(Duration(seconds: 1)),
      );
    }, // fi group
  );
}
