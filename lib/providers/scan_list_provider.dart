import 'package:flutter/material.dart';
import 'package:qr_scanner_omar/models/scan_model.dart';
import 'package:qr_scanner_omar/providers/db_provider.dart';

class ScanListProvider extends ChangeNotifier {
  List<ScanModel> scans = [];
  String selectedType = 'http';
  newScan(String value) async {
    final newScan = new ScanModel(valor: value);
    final id = await DBProvider.db.nuevoScan(newScan);
    // Asignar el ID de la base de datos al modelo
    newScan.id = id;
    //Se insertará en la BD, pero sólo se mostrará en la interfaz si el tipo
    //seleccionado es el mismo al del scan. Podríamos estar en la tab de Maps
    //y que hayamos cargado una dirección.. o al revés
    if (this.selectedType == newScan.tipo) {
      this.scans.add(newScan);
      notifyListeners();
    }
  }

  loadScans() async {
    final scans = await DBProvider.db.getAllScans();
    this.scans = [...scans];
    notifyListeners();
  }

  loadScanByType(String tipo) async {
    final scans = await DBProvider.db.getScansByTipo(tipo);
    this.scans = [...scans];
    this.selectedType = tipo;
    notifyListeners();
  }

  deleteAll() async {
    await DBProvider.db.deleteAllScans();
    this.scans = [];
    notifyListeners();
  }

  deleteScanById(int id) async {
    await DBProvider.db.deleteScan(id);
    this.loadScanByType(this.selectedType);
  }
  
}
