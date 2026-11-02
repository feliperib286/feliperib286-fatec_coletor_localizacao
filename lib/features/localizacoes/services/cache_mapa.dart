import 'dart:io';
import 'package:path_provider/path_provider.dart';

class CacheMapa {
  Future<String> obterPastaPrivadaCache() async {
    final diretorio = await getApplicationDocumentsDirectory();
    final pastaCache = Directory('${diretorio.path}/map_tiles');
    if (!await pastaCache.exists()) {
      await pastaCache.create(recursive: true);
    }
    return pastaCache.path;
  }
}
