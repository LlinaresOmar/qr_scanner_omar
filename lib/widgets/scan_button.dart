import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:url_launcher/url_launcher.dart';

class ScanButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.filter_center_focus),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => QRScannerScreen(),
          ),
        );
      },
    );
  }
}

class QRScannerScreen extends StatelessWidget {
  // Función para lanzar una URL escaneada en el navegador
  Future<void> _launchUrl(BuildContext context, String url) async {
    final uri = Uri.tryParse(url);
    if (uri != null) {
      // Intenta abrir la URL directamente en el navegador
      try {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } catch (e) {
        // Si hay un error al abrir la URL, muestra un mensaje
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al intentar abrir la URL: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se pudo abrir la URL')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Escanear código QR')),
      body: MobileScanner(
        onDetect: (capture) {
          final barcode =
              capture.barcodes.first; 
          final String? url =
              barcode.rawValue;
          print('Código escaneado: $url');
          if (url != null && Uri.tryParse(url)?.hasScheme == true) {
            _launchUrl(context, url);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('No se detectó un código válido')),
            );
          }
        },
      ),
    );
  }
}