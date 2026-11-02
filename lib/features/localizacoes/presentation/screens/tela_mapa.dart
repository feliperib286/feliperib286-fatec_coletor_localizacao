import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../data/repositories/repositorio_localizacoes.dart';
import '../../models/localizacao.dart';

class TelaMapa extends StatefulWidget {
  const TelaMapa({super.key});

  @override
  State<TelaMapa> createState() => _TelaMapaState();
}

class _TelaMapaState extends State<TelaMapa> {
  final RepositorioLocalizacoes _repositorio = RepositorioLocalizacoes();
  final MapController _mapController = MapController();
  List<Localizacao> _pontos = [];

  @override
  void initState() {
    super.initState();
    _carregarPontos();
  }

  Future<void> _carregarPontos() async {
    final dados = await _repositorio.consultarUltimas100();
    setState(() {
      _pontos = dados;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_pontos.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Mapa')),
        body: const Center(child: Text('Sem pontos.')),
      );
    }

    final marcadores = _pontos.asMap().entries.map((entry) {
      return Marker(
        point: LatLng(entry.value.latitude, entry.value.longitude),
        width: 30,
        height: 30,
        child: Icon(Icons.location_pin, color: entry.key == 0 ? Colors.red : Colors.blue),
      );
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Mapa')),
      body: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          initialCenter: LatLng(_pontos.first.latitude, _pontos.first.longitude),
          initialZoom: 15.0,
        ),
        children: [
          TileLayer(urlTemplate: 'https://openstreetmap.org{z}/{x}/{y}.png'),
          MarkerLayer(markers: marcadores),
        ],
      ),
    );
  }
}
