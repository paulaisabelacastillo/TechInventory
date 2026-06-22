import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/book.dart';
import '../providers/book_provider.dart';

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
  final ImagePicker _picker = ImagePicker();

  String _imagePath = '';

  @override
  void dispose() {
    _codigoController.dispose();
    _nombreController.dispose();
    _descripcionController.dispose();
    super.dispose();
  }

  String? _validarCampo(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Campo obligatorio';
    }

    return null;
  }

  void _limpiarFormulario() {
    _codigoController.clear();
    _nombreController.clear();
    _descripcionController.clear();
    _formKey.currentState?.reset();
    setState(() {
      _imagePath = '';
    });
  }

  void _mostrarMensaje(String mensaje) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(mensaje)));
  }

  Future<void> _capturarFoto(StateSetter setModalState) async {
    try {
      final photo = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
        maxWidth: 1280,
      );

      if (photo == null || !mounted) return;

      setState(() {
        _imagePath = photo.path;
      });
      setModalState(() {
        _imagePath = photo.path;
      });
    } catch (_) {
      if (!mounted) return;
      _mostrarMensaje('No se pudo abrir la cámara.');
    }
  }

  Future<void> _guardarFormulario() async {
    if (!_formKey.currentState!.validate()) return;

    if (_imagePath.isEmpty) {
      _mostrarMensaje('Por favor, tome una fotografía del equipo.');
      return;
    }

    final provider = context.read<EquipoProvider>();
    final fechaActual = DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now());

    await provider.addEquipo(
      codigo: _codigoController.text.trim(),
      nombre: _nombreController.text.trim(),
      descripcion: _descripcionController.text.trim(),
      fecha: fechaActual,
      foto: _imagePath,
    );

    if (!mounted) return;

    Navigator.of(context).pop();
    _mostrarMensaje('Equipo registrado correctamente.');
    _limpiarFormulario();
  }

  void _confirmarEliminar(BuildContext context, Equipo equipo) {
    if (equipo.id == null) return;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Confirmar eliminación'),
        content: Text(
          '¿Seguro que deseas eliminar el equipo "${equipo.nombre}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(dialogContext).pop();
              await context.read<EquipoProvider>().deleteEquipo(equipo.id!);
              if (!mounted) return;
              _mostrarMensaje('Equipo eliminado.');
            },
            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _abrirFormulario() {
    _limpiarFormulario();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          return Padding(
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
                    Row(
                      children: [
                        const Icon(Icons.computer, color: Colors.indigo),
                        const SizedBox(width: 8),
                        Text(
                          'Registrar equipo',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _codigoController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Código',
                        prefixIcon: Icon(Icons.qr_code_2),
                      ),
                      textInputAction: TextInputAction.next,
                      validator: _validarCampo,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _nombreController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Nombre del equipo',
                        prefixIcon: Icon(Icons.devices),
                      ),
                      textInputAction: TextInputAction.next,
                      validator: _validarCampo,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _descripcionController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Descripción',
                        prefixIcon: Icon(Icons.description),
                      ),
                      maxLines: 3,
                      textInputAction: TextInputAction.done,
                      validator: _validarCampo,
                    ),
                    const SizedBox(height: 16),
                    _FotoPreview(path: _imagePath),
                    const SizedBox(height: 10),
                    OutlinedButton.icon(
                      onPressed: () => _capturarFoto(setModalState),
                      icon: const Icon(Icons.add_a_photo),
                      label: const Text('Usar cámara'),
                    ),
                    const SizedBox(height: 20),
                    FilledButton.icon(
                      onPressed: _guardarFormulario,
                      icon: const Icon(Icons.save),
                      label: const Text('Guardar'),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TechInventory'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: Consumer<EquipoProvider>(
        builder: (context, provider, child) {
          if (provider.equipos.isEmpty) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.inventory_2_outlined,
                    size: 56,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 12),
                  Text('No hay equipos registrados.'),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: provider.equipos.length,
            itemBuilder: (context, index) {
              final equipo = provider.equipos[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(12),
                  leading: _FotoMiniatura(path: equipo.foto),
                  title: Text(
                    equipo.nombre,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Código: ${equipo.codigo}'),
                        Text('Fecha: ${equipo.fecha}'),
                        if (equipo.descripcion.isNotEmpty)
                          Text(
                            equipo.descripcion,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                  ),
                  trailing: IconButton(
                    tooltip: 'Eliminar',
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
        backgroundColor: Colors.indigo,
        tooltip: 'Registrar equipo',
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class _FotoPreview extends StatelessWidget {
  const _FotoPreview({required this.path});

  final String path;

  @override
  Widget build(BuildContext context) {
    final hasPhoto = path.isNotEmpty && File(path).existsSync();

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Container(
        height: 150,
        width: double.infinity,
        color: Colors.grey.shade200,
        child: hasPhoto
            ? Image.file(
                File(path),
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.broken_image, size: 48);
                },
              )
            : const Center(
                child: Icon(Icons.camera_alt, size: 48, color: Colors.grey),
              ),
      ),
    );
  }
}

class _FotoMiniatura extends StatelessWidget {
  const _FotoMiniatura({required this.path});

  final String path;

  @override
  Widget build(BuildContext context) {
    final hasPhoto = path.isNotEmpty && File(path).existsSync();

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Container(
        height: 56,
        width: 56,
        color: Colors.grey.shade200,
        child: hasPhoto
            ? Image.file(
                File(path),
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.computer, color: Colors.grey);
                },
              )
            : const Icon(Icons.computer, color: Colors.grey),
      ),
    );
  }
}
