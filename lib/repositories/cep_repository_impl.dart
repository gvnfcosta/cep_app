import 'package:cep_app/models/endereco_model.dart';
import 'package:cep_app/repositories/cep_repository.dart';
import 'package:dio/dio.dart';
import 'dart:developer' as developer;

class CepRepositoryImpl implements CepRepository {
  @override
  Future<EnderecoModel> getCep(String cep) async {

try {
    final response = await Dio().get('https://viacep.com.br/ws/$cep/json/');
    if (response.statusCode == 200) {
      return EnderecoModel.fromMap(response.data);
    } else {
      throw Exception('Erro ao buscar CEP: Status ${response.statusCode}');
    }
  } on DioException catch (e) {
    developer.log('Erro ao buscar CEP', error: e, stackTrace: e.stackTrace);
    if (e.response != null) {
      // Erro com resposta do servidor
      throw Exception('Erro ao buscar CEP: ${e.response?.statusCode} - ${e.response?.data}');
    } else if (e.type == DioExceptionType.connectionTimeout) {
      throw Exception('Erro ao buscar CEP: Tempo de conexão esgotado');
    } else if (e.type == DioExceptionType.receiveTimeout) {
      throw Exception('Erro ao buscar CEP: Tempo de resposta esgotado');
    } else if (e.type == DioExceptionType.badResponse) {
      throw Exception('Erro ao buscar CEP: Resposta inválida do servidor');
    } else {
      throw Exception('Erro ao buscar CEP: ${e.message}');
    }
  } catch (e) {
    developer.log('Erro inesperado ao buscar CEP', error: e);
    throw Exception('Erro inesperado ao buscar CEP');
  }
  }
}