import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_scanner_omar/models/scan_model.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  // Instancia estática privada de la base de datos.
  static Database? _database;

  // Instancia Singleton de DBProvider.
  static final DBProvider db = DBProvider._();

  // Constructor privado para asegurar que solo se cree una instancia.
  DBProvider._();

  // Getter asíncrono que devuelve la instancia de la base de datos.
  Future<Database?> get database async {
    // Si la base de datos ya está inicializada, se devuelve la misma instancia.
    if (_database != null) return _database;

    // Si no está inicializada, se llama a initDB() para configurarla.
    _database = await initDB();
    return _database;
  }

  // Método para inicializar la base de datos.
  Future<Database> initDB() async {
    // Obtiene el directorio de almacenamiento del dispositivo.
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'ScansDB.db');

    print(
        'Ruta de la base de datos: $path'); // Para verificar la ubicación de la BD.

    // Abre y crea la base de datos con la estructura definida.
    return await openDatabase(
      path,
      version: 1,
      onOpen: (db) {},
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE Scans (
            id INTEGER PRIMARY KEY,
            tipo TEXT,
            valor TEXT
          )
        ''');
      },
    );
  }

  // Opcion 1
  Future<int> nuevoScanRaw(ScanModel nuevoScan) async {
    final id = nuevoScan.id;
    final tipo = nuevoScan.tipo;
    final valor = nuevoScan.valor;
    //Getter de la BD, que verifica la BD
    final db = await database;
    final res = await db!.rawInsert('''
      INSERT INTO Scans(id, tipo, valor)
      VALUES ( '$id', '$tipo' , '$valor' )
      ''');
    return res;
  }

  // Opcion 2
  Future<int> nuevoScan(ScanModel nuevoScan) async {
    final db = await database;
    final res = await db!.insert('Scans', nuevoScan.toJson());
    print(res);
    return res;
  }

  Future<ScanModel?> getScanById(int id) async {
    final db = await database;
    
    final res = await db?.query('Scans', where: 'id = ?', whereArgs: [id]);
    
    return res != null && res.isNotEmpty ? ScanModel.fromJson(res.first) : null;
  }

  Future<List<ScanModel>> getAllScans() async {
    final db = await database;
    final res = await db!.query('Scans');
    
    return res.isNotEmpty
        ? res.map((s) => ScanModel.fromJson(s)).toList()
        : [];
  }

  Future<List<ScanModel>> getScansByTipo(String tipo) async {
    final db = await database;
    
    final res = await db!.rawQuery(
      'SELECT * FROM Scans WHERE tipo = ?',
      [tipo]
    );

    return res.isNotEmpty
        ? res.map((s) => ScanModel.fromJson(s)).toList()
        : [];
  }

  Future<int> updateScan(ScanModel newScan) async {
    final db = await database;
    final res = await db!.update('Scans', newScan.toJson(),
    where: 'id = ?', whereArgs: [newScan.id]);
    return res;
  }

  Future<int> deleteScan(int id) async {
    final db = await database;
    final res = await db!.delete('Scans', where: 'id = ?', whereArgs: [id]);
    return res;
  }
  
  Future<int> deleteAllScans() async {
    final db = await database;
    final res = await db!.delete('Scans');
    return res;
  }
}
