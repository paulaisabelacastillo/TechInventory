import 'package:flutter/material.dart';
import '../services/db_service.dart';
import '../models/book.dart';

class BookProvider with ChangeNotifier {
  List<Equipo> _equipos = [];
  final DbService _dbService = DbService();

  List<Equipo> get equipos => _equipos;

  Future<void> loadEquipos() async {
    _equipos = await _dbService.getEquipos();
    notifyListeners();
  }

  Future<void> addEquipo(String codigo, String nombre, String descripcion, String fecha, String foto) async {
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
