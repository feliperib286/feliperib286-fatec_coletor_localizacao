import 'package:flutter/material.dart';
import '../../models/localizacao.dart';
import '../../data/repositories/repositorio_localizacoes.dart';
import '../widgets/item_localizacao.dart';

class TelaLocalizacoes extends StatefulWidget {
  const TelaLocalizacoes({super.key});

  @override
  State<TelaLocalizacoes> createState() => _TelaLocalizacoesState();
}

class _TelaLocalizacoesState extends State<TelaLocalizacoes> {
  final RepositorioLocalizacoes _repositorio = RepositorioLocalizacoes();
  List<Localizacao> _historico = [];

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  Future<void> _carregarDados() async {
    final dados = await _repositorio.consultarUltimas100();
    if (mounted) {
      setState(() => _historico = dados);
    }
  }

  void _confirmarLimpeza() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Limpar Histórico'),
        content: const Text('Esta operação é permanente.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar')),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await _repositorio.limparHistorico();
              await _carregarDados();
            },
            child: const Text('Limpar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Histórico'),
        actions: [IconButton(icon: const Icon(Icons.delete_forever), onPressed: _confirmarLimpeza)],
      ),
      body: _historico.isEmpty
          ? const Center(child: Text('Nenhum registro.'))
          : ListView.builder(
              itemCount: _historico.length,
              itemBuilder: (context, index) => ItemLocalizacao(localizacao: _historico[index]),
            ),
    );
  }
}
