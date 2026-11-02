import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../../models/localizacao.dart';
import '../../services/servico_localizacoes.dart';
import '../../data/repositories/repositorio_localizacoes.dart';
import 'tela_localizacao.dart';
import 'tela_mapa.dart';

class TelaColeta extends StatefulWidget {
  const TelaColeta({super.key});

  @override
  State<TelaColeta> createState() => _TelaColetaState();
}

class _TelaColetaState extends State<TelaColeta> {
  final ServicoLocalizacao _servico = ServicoLocalizacao();
  final RepositorioLocalizacoes _repositorio = RepositorioLocalizacoes();
  
  StreamSubscription<Position>? _subexibicao;
  bool _coletando = false;

  void _iniciarColeta() async {
    bool permitido = await _servico.verificarETratarPermissao();
    if (!permitido) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Permissão negada ou GPS desligado.')),
        );
      }
      return;
    }

    if (_subexibicao != null) return;

    setState(() => _coletando = true);

    _subexibicao = _servico.obterStreamPosicoes().listen((Position posicao) async {
      final novaLocalizacao = Localizacao(
        latitude: posicao.latitude,
        longitude: posicao.longitude,
        precisao: posicao.accuracy,
        instante: DateTime.now(),
      );
      
      await _repositorio.inserir(novaLocalizacao);
    }, onError: (erro) {
      if (mounted) {
        setState(() => _coletando = false);
        _subexibicao?.cancel();
        _subexibicao = null;
      }
    });
  }

  void _pararColeta() {
    if (_subexibicao != null) {
      _subexibicao!.cancel();
      _subexibicao = null;
    }
    setState(() => _coletando = false);
  }

  @override
  void dispose() {
    _subexibicao?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Coletor FATEC')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton(
                onPressed: _coletando ? null : _iniciarColeta,
                child: const Text('Iniciar Coleta'),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _coletando ? _pararColeta : null,
                child: const Text('Parar Coleta'),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TelaLocalizacoes())),
                child: const Text('Consultar Histórico'),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TelaMapa())),
                child: const Text('Ver Mapa'),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _servico.abrirConfiguracoes,
                child: const Text('Configurações de Permissão'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
