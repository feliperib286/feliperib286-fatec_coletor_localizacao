import 'package:fatec_coletor_localizacao/features/localizacoes/data/database/banco_localizacoes.dart';
import 'package:fatec_coletor_localizacao/features/localizacoes/models/localizacao.dart';

class RepositorioLocalizacoes {
  final BancoLocalizacoes _banco = BancoLocalizacoes();

  Future<int> inserir(Localizacao localizacao) async {
    final db = await _banco.database;
    return await db.insert('localizacoes', localizacao.toMap());
  }

  Future<List<Localizacao>> consultarUltimas100() async {
    final db = await _banco.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'localizacoes',
      orderBy: 'id DESC',
      limit: 100,
    );
    return maps.map((map) => Localizacao.fromMap(map)).toList();
  }

  Future<int> limparHistorico() async {
    final db = await _banco.database;
    return await db.delete('localizacoes');
  }
}
