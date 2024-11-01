import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_scanner_omar/providers/scan_list_provider.dart';

class MapsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final scanListProvider = Provider.of<ScanListProvider>(context);
    final scans = scanListProvider.scans;
      return ListView.builder(
        itemCount: scans.length,
        itemBuilder: (_, i) => ListTile(
        leading: Icon(Icons.map, color: Theme.of(context).primaryColor),
        title: Text(scans[i].valor),
        subtitle: Text(scans[i].id.toString()),
        trailing: Icon(Icons.keyboard_arrow_right, color: Colors.grey),
        onTap: () => print('abrir algo...'),
      ));
  }
}
