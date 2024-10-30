import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_scanner_omar/pages/address_page.dart';
import 'package:qr_scanner_omar/pages/maps_page.dart';
import 'package:qr_scanner_omar/providers/scan_list_provider.dart';
import 'package:qr_scanner_omar/providers/ui_provider.dart';
import 'package:qr_scanner_omar/widgets/custom_navigatorbar.dart';
import 'package:qr_scanner_omar/widgets/scan_button.dart';

class HomePage extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Historial'),
        actions: [
          IconButton(icon: Icon(Icons.delete_forever), onPressed: () {
            Provider.of<ScanListProvider>(context, listen: false).deleteAll();
          })
        ],
      ),
      body: _HomePageBody(),
      bottomNavigationBar: CustomNavigationBar(),
      floatingActionButton: ScanButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

class _HomePageBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final scanListProvider = Provider.of<ScanListProvider>(context, listen: false);
    // Obtener el selected menu opt
    final uiProvider = Provider.of<UiProvider>(context);
    final currentIndex = uiProvider.selectedMenuOpt;

    // Cargar scans según el índice seleccionado
    switch (currentIndex) {
      case 0:
        scanListProvider.loadScanByType('geo');
        return MapsPage();
      case 1:
        scanListProvider.loadScanByType('http');
        return AddressesPage();
      default:
        // Devolver MapsPage como predeterminado
        scanListProvider.loadScanByType('geo'); // Cargar geo como valor por defecto
        return MapsPage();
    }
  }
}
