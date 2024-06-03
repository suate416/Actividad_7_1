import 'dart:async';
import 'package:tareas_application_1/model/tarea.dart';

class GestorTareas {
  final StreamController<List<Tareas>> _streamController = StreamController<List<Tareas>>();
  List<Tareas> _tareas = [];

  Stream<List<Tareas>> tareaStream() {
    return _streamController.stream;
  }

  void agregarTarea(String titulo, String descripcion) {
    final nuevaTarea = Tareas(titulo: titulo, descripcion: descripcion);
    _tareas.add(nuevaTarea);
    _streamController.add(List.from(_tareas));
  }

  void editarTarea(int index, String nuevoTitulo, String nuevaDescripcion) {
    _tareas[index].titulo = nuevoTitulo;
    _tareas[index].descripcion = nuevaDescripcion;
    _streamController.add(List.from(_tareas));
  }

  void deleteItem(int index) {
    _tareas.removeAt(index);
    _streamController.add(List.from(_tareas));
  }

  void dispose() {
    _streamController.close();
  }
}
