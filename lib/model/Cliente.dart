import 'package:geolocator/geolocator.dart';

class Cliente{

  String _nome;
  String _email;
  String _telefone;
  String _endereco;
  String _localizacao;
  String _localizacaoPrecisao;
  String _possuiInternet;
  String _qualPlano;
  String _qualValor;
  String _temFidelidade;
  bool _interesseReceberProp;
  bool _estaSatisf;
  String _quandAcabaFidelidade;
  bool _interesEmMudar;
  String _vendedorEmail;
  String _vendedorNome;

  String get vendedorEmail => _vendedorEmail;

  String get vendedorNome => _vendedorNome;

  set vendedorEmail(String value) {
    _vendedorEmail = value;
  }
  set vendedorNome(String value) {
    _vendedorNome = value;
  }


  Cliente();
  Map<String, dynamic> toMapSimple(){
    Map<String, dynamic> map = {
      "nome" : this.nome,
      "email" : this.email,
      "telefone" : this.telefone,
      "endereco" : this.endereco,
      "localizacao" : this.localizacao,
      "localizacaoPrecisao" : this.localizacaoPrecisao,
      "vendedorEmail" : this.vendedorEmail,
      "vendedorNome" : this.vendedorNome,
    };
    return map;
  }
  Map<String, dynamic> toMapAdvanced(){
    Map<String, dynamic> map = {
      "nome" : this.nome,
      "email" : this.email,
      "telefone" : this.telefone,
      "endereco" : this.endereco,
      "localizacao" : this.localizacao,
      "localizacaoPrecisao" : this.localizacaoPrecisao,
      "possuiInternet" : this.possuiInternet,
      "qualPlano" : this.qualPlano,
      "qualValor" : this.qualValor,
      "temFidelidade" : this.temFidelidade,
      "interesseReceberProp" : this.interesseReceberProp,
      "estaSatisf" : this.estaSatisf,
      "quandAcabaFidelidade" : this.quandAcabaFidelidade,
      "interesEmMudar" : this.interesEmMudar,
      "vendedorEmail" : this.vendedorEmail,
      "vendedorNome" : this.vendedorNome,
    };
    return map;
  }

  String get email => _email;

  set email(String value) {
    _email = value;
  }

  String get nome => _nome;

  set nome(String value) {
    _nome = value;
  }

  String get telefone => _telefone;

  set telefone(String value) {
    _telefone = value;
  }

  String get endereco => _endereco;

  set endereco(String value) {
    _endereco = value;
  }

  String get localizacao => _localizacao;
  String get localizacaoPrecisao => _localizacaoPrecisao;

  set localizacao(String value) {
    _localizacao = value;
  }
  set localizacaoPrecisao(String value) {
    _localizacaoPrecisao = value;
  }
  String get possuiInternet => _possuiInternet;

  set possuiInternet(String value) {
    _possuiInternet = value;
  }

  String get qualPlano => _qualPlano;

  set qualPlano(String value) {
    _qualPlano = value;
  }

  String get qualValor => _qualValor;

  set qualValor(String value) {
    _qualValor = value;
  }

  String get temFidelidade => _temFidelidade;

  set temFidelidade(String value) {
    _temFidelidade = value;
  }

  bool get interesseReceberProp => _interesseReceberProp;

  set interesseReceberProp(bool value) {
    _interesseReceberProp = value;
  }

  bool get estaSatisf => _estaSatisf;

  set estaSatisf(bool value) {
    _estaSatisf = value;
  }

  String get quandAcabaFidelidade => _quandAcabaFidelidade;

  set quandAcabaFidelidade(String value) {
    _quandAcabaFidelidade = value;
  }

  bool get interesEmMudar => _interesEmMudar;

  set interesEmMudar(bool value) {
    _interesEmMudar = value;
  }


}