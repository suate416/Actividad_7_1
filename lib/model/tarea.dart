class Tareas {
  String titulo;
  String descripcion;
  bool completada;

  Tareas({
    required this.titulo,
    required this.descripcion,
    this.completada = false,
  });
}