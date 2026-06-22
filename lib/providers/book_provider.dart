import 'package:flutter/material.dart';

import '../models/book.dart';
import '../services/db_service.dart';

class EquipoProvider with ChangeNotifier {
  final DbService _dbService = DbService();
  List<Equipo> _equipos = [];

  List<Equipo> get equipos => List.unmodifiable(_equipos);

  Future<void> loadEquipos() async {
    _equipos = await _dbService.getEquipos();
    notifyListeners();
  }

  Future<void> addEquipo({
    required String codigo,
    required String nombre,
    required String descripcion,
    required String fecha,
    required String foto,
  }) async {
    final nuevoEquipo = Equipo(
      codigo: codigo,
      nombre: nombre,
      descripcion: descripcion,
      fecha: fecha,
      foto: foto,
    );

    await _dbService.insertEquipo(nuevoEquipo);
    await loadEquipos();
  }

  Future<void> deleteEquipo(int id) async {
    await _dbService.deleteEquipo(id);
    await loadEquipos();
  }
}
