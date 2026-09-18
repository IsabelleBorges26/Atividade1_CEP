import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/pessoa.dart';

class PessoaService {
  static const String chave = 'pessoas';

  Future<List<Pessoa>> listarPessoas() async {
    final prefs = await SharedPreferences.getInstance();
    final dados = prefs.getStringList(chave) ?? [];

    return dados
        .map((item) => Pessoa.fromJson(jsonDecode(item)))
        .toList();
  }

  Future<void> salvarPessoa(Pessoa pessoa) async {
    final prefs = await SharedPreferences.getInstance();

    final pessoas = await listarPessoas();
    pessoas.add(pessoa);

    final dados = pessoas
        .map((item) => jsonEncode(item.toJson()))
        .toList();

    await prefs.setStringList(chave, dados);
  }
}
