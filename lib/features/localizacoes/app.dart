import 'package:flutter/material.dart';
import 'package:fatec_coletor_localizacao/features/localizacoes/presentation/screens/tela_coleta.dart';
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Coletor FATEC',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: TelaColeta(),
      debugShowCheckedModeBanner: false,
    );
  }
}
