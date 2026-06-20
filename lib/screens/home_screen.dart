import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../providers/book_provider.dart';
import '../models/book.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _codigoController = TextEditingController();
  final _nombreController = TextEditingController();
  final _descripcionController = TextEditingController();
  
  String _imagePath = '';
  final ImagePicker _picker = ImagePicker();

  Future<void> _capturarFoto() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      setState(() {
        _imagePath = photo.path;
      });
    }
  }

  void _guardarFormulario() {
    if (!_formKey.currentState!.validate()) return;
    if (_imagePath.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, tome una fotografía del equipo.')),
      );
      return;
    }

    final String fechaActual = DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now());

    Provider.of<BookProvider>(context, listen: false).addEquipo(
      _codigoController.text,
      _nombreController.text,
      _descripcionController.text,
      fechaActual,
      _imagePath,
    );

    _codigoController.clear();
    _nombreController.clear();
    _descripcionController.clear();
    setState(() {
      _imagePath = '';
    });
    Navigator.pop(context);
  }

  void _confirmarEliminar(BuildContext context, Equipo equipo) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar eliminación'),
        content: Text('¿Seguro que deseas eliminar el equipo "${equipo.nombre}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Provider.of<BookProvider>(context, listen: false).deleteEquipo(equipo.id!);
              Navigator.pop(context);
            },
            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _abrirFormulario() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: EdgeInsets.only(
            top: 20,
            left: 20,
            right: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text('Registrar Equipo', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: _codigoController,
                    decoration: const InputDecoration(labelText: 'Código del Equipo', border: OutlineInputBorder()),
                    validator: (value) => value!.isEmpty ? 'Campo obligatorio' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _nombreController,
                    decoration: const InputDecoration(labelText: 'Nombre del Equipo', border: OutlineInputBorder()),
                    validator: (value) => value!.isEmpty ? 'Campo obligatorio' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _descripcionController,
                    decoration: const InputDecoration(labelText: 'Descripción', border: OutlineInputBorder()),
                    maxLines: 2,
                    validator: (value) => value!.isEmpty ? 'Campo obligatorio' : null,
                  ),
                  const SizedBox(height: 15),
                  Column(
                    children: [
                      _imagePath.isEmpty
                          ? const Icon(Icons.camera_alt, size: 50, color: Colors.grey)
                          : Image.file(File(_imagePath), height: 120, width: double.infinity, fit: BoxFit.cover),
                      const SizedBox(height: 8),
                      ElevatedButton.icon(
                        onPressed: () async {
                          final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
                          if (photo != null) {
                            setModalState(() {
                              _imagePath = photo.path;
                            });
                            setState(() {
                              _imagePath = photo.path;
                            });
                          }
                        },
                        icon: const Icon(Icons.add_a_photo),
                        label: const Text('Usar Cámara'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _guardarFormulario,
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                    child: const Text('Guardar en TechInventory'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TechInventory - Equipos'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Consumer<BookProvider>(
        builder: (context, provider, child) {
          if (provider.equipos.isEmpty) {
            return const Center(child: Text('No hay equipos registrados.'));
          }
          return ListView.builder(
            itemCount: provider.equipos.length,
            itemBuilder: (context, index) {
              final equipo = provider.equipos[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ListTile(
                  leading: equipo.foto.isNotEmpty
                      ? CircleAvatar(radius: 25, backgroundImage: FileImage(File(equipo.foto)))
                      : const CircleAvatar(radius: 25, child: Icon(Icons.computer)),
                  title: Text(equipo.nombre),
                  subtitle: Text('Código: ${equipo.codigo}\nFecha: ${equipo.fecha}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _confirmarEliminar(context, equipo),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _abrirFormulario,
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
