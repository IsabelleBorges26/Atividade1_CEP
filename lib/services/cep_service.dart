import 'dart:convert';

import 'package:http/http.dart' as http;

class CepService {
  Future<Map<String, dynamic>?> buscarCep(String cep) async {
    final cepLimpo = cep.replaceAll(RegExp(r'[^0-9]'), '');

    if (cepLimpo.length != 8) {
      return null;
    }

    final url = Uri.parse('https://viacep.com.br/ws/$cepLimpo/json/');

    try {
      final resposta = await http.get(url);

      if (resposta.statusCode != 200) {
        return null;
      }

      final dados = jsonDecode(resposta.body);

      if (dados['erro'] == true) {
        return null;
      }

      return dados;
    } catch (e) {
      return null;
    }
  }
}
