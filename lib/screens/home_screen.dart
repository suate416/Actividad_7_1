import 'dart:async';
import 'package:flutter/material.dart';
import 'package:tareas_application_1/model/tarea.dart';
import 'package:tareas_application_1/gestor_estado.dart';

const TextStyle tituloScreenFont = TextStyle(
  fontSize: 40,
  fontWeight: FontWeight.bold,
  color: Colors.white,
);
const TextStyle tituloFont = TextStyle(
  fontSize: 29,
  fontWeight: FontWeight.w400,
);
const TextStyle descripcionFont =
    TextStyle(fontSize: 25, fontStyle: FontStyle.italic);

class ListaStreams extends StatefulWidget {
  const ListaStreams({super.key});

  @override
  State<ListaStreams> createState() => _ListaStreamsState();
}

class _ListaStreamsState extends State<ListaStreams> {
final GestorTareas _GestorTareas = GestorTareas();
final TextEditingController _tituloController = TextEditingController();
final TextEditingController _descripcionController = TextEditingController();
@override
void dispose() {
  _GestorTareas.dispose();
  _tituloController.dispose();
  _descripcionController.dispose();
  super.dispose();
}
@override
Widget build(BuildContext context) {
return GestureDetector(
  onTap: () {
    FocusScope.of(context).unfocus();
  },
  child: Scaffold(
    backgroundColor: const Color.fromARGB(255, 255, 222, 211),
    appBar: AppBar(
      title: const Text(
        'Lista de Tareas',
        style: tituloScreenFont,
      ),
      centerTitle: true,
      toolbarHeight: 100,
      backgroundColor: Colors.brown[400],
    ),
    body: Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
          child: Column(
            children: [
              TextField(
                controller: _tituloController,
                decoration: const InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 98, 30, 5),
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 98, 30, 5),
                    ),
                  ),
                  labelText: 'Titulo',
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _descripcionController,
                decoration: const InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 98, 30, 5),
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 98, 30, 5),
                    ),
                  ),
                  labelText: 'Descripcion',
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(
                        Color.fromARGB(255, 138, 90, 75)),
                    foregroundColor:
                        MaterialStatePropertyAll(Colors.white)),
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  if (_tituloController.text.isNotEmpty &&
                      _descripcionController.text.isNotEmpty) {
                    _GestorTareas.agregarTarea(
                      _tituloController.text.toUpperCase(),
                      _descripcionController.text,
                    );
                    _tituloController.clear();
                    _descripcionController.clear();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content:
                            Text('Todas las casillas deben estar llenas'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                child: const Text(
                  'Agregar Tarea',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: StreamBuilder<List<Tareas>>(
            stream: _GestorTareas.tareaStream(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final tarea = snapshot.data![index];
                    return ListTile(
                      title: Text(
                        '${index + 1}. ${tarea.titulo}',
                        style: tituloFont,
                      ),
                      subtitle: Text(
                        tarea.descripcion,
                        style: descripcionFont,
                      ),
                      leading: Transform.scale(
                        scale: 1.8,
                        child: Checkbox(
                          side: const BorderSide(
                              color: Color.fromARGB(255, 86, 23, 5)),
                          checkColor: Colors.white,
                          fillColor:
                              MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                              if (states.contains(MaterialState.selected)) {
                                return Colors.brown[700]!;
                              }
                              return const Color.fromARGB(
                                  255, 244, 227, 222);
                            },
                          ),
                          value: tarea.completada,
                          onChanged: (completa) {
                            setState(() {
                              tarea.completada = completa ?? false;
                              _GestorTareas.tareaStream();
                            });
                          },
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  String nuevoTitulo = tarea.titulo;
                                  String nuevaDescripcion =
                                      tarea.descripcion;
                                  return AlertDialog(
                                    title:
                                        Text('Editar Tarea #${index + 1}'),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        TextField(
                                          onChanged: (value) {
                                            nuevoTitulo = value;
                                          },
                                          controller: TextEditingController(
                                              text: tarea.titulo),
                                          decoration: const InputDecoration(
                                              hintText: 'Nuevo titulo'),
                                        ),
                                        const SizedBox(height: 8),
                                        TextField(
                                          onChanged: (value) {
                                            nuevaDescripcion = value;
                                          },
                                          controller: TextEditingController(
                                              text: tarea.descripcion),
                                          decoration: const InputDecoration(
                                              hintText:
                                                  'Nueva descripcion'),
                                        ),
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('Cancelar'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          _GestorTareas.editarTarea(
                                              index,
                                              nuevoTitulo,
                                              nuevaDescripcion);
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('Guardar'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            icon: Icon(Icons.edit,
                                size: 35, color: Colors.brown[700]),
                          ),
                          IconButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text(
                                        'Eliminar Tarea #${index + 1}'),
                                    content: Text(
                                        'Deseas elimar ${tarea.titulo}?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('Cancelar'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          _GestorTareas.deleteItem(index);
                                        },
                                        child: const Text('Eliminar'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            icon: Icon(Icons.delete,
                                size: 35, color: Colors.brown[700]),
                          ),
                        ],
                      ),
                    );
                  },
                );
              } else {
                return const Center(child: Text('No hay tareas'));
                }
              },
            ),
          ),
        ],
      ),
    ),
    );
  }
}
