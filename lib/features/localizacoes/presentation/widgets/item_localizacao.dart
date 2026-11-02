import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/localizacao.dart';

class ItemLocalizacao extends StatelessWidget {
  final Localizacao localizacao;
  const ItemLocalizacao({super.key, required this.localizacao});

  @override
  Widget build(BuildContext context) {
    final String dataFormatada = DateFormat('dd/MM/yyyy HH:mm:ss').format(localizacao.instante);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        leading: const Icon(Icons.location_on, color: Colors.blue),
        title: Text(dataFormatada),
        subtitle: Text(
          'Lat: ${localizacao.latitude.toStringAsFixed(6)}\n'
          'Lon: ${localizacao.longitude.toStringAsFixed(6)}\n'
          'Precisão: ${localizacao.precisao.toStringAsFixed(1)}m',
        ),
      ),
    );
  }
}
