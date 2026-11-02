import 'dart:async';
import 'package:geolocator/geolocator.dart';

class ServicoLocalizacao {
  Future<bool> verificarETratarPermissao() async {
    bool servicoAtivo = await Geolocator.isLocationServiceEnabled();
    if (!servicoAtivo) return false;

    LocationPermission permissao = await Geolocator.checkPermission();
    if (permissao == LocationPermission.denied) {
      permissao = await Geolocator.requestPermission();
      if (permissao == LocationPermission.denied) return false;
    }

    if (permissao == LocationPermission.deniedForever) return false;
    return true;
  }

  Stream<Position> obterStreamPosicoes() {
    return Geolocator.getPositionStream(
      locationSettings:  AndroidSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 0,
        intervalDuration: Duration(seconds: 20),
      ),
    );
  }

  Future<void> abrirConfiguracoes() async {
    await Geolocator.openAppSettings();
  }
}
