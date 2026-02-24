enum TipusAccio { seleccionar, destacar, esborrar }

class ElementImatge {
  final int id;
  final String titol;
  final String path;

  const ElementImatge({
    // Claus indiquen que els atributs d'entrada són amb nom.
    required this.id,
    required this.titol,
    required this.path,
  });
}
