import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:netcompany_prospeccoes/model/Cliente.dart';
class AbaCadastrarClientes extends StatefulWidget {
  @override
  _AbaCadastrarClientesState createState() => _AbaCadastrarClientesState();
}

class _AbaCadastrarClientesState extends State<AbaCadastrarClientes> {


  //Controlador
  TextEditingController _controllerNome = TextEditingController();
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerTelefone =
      MaskedTextController(mask: '(00) 00000-0000');
  TextEditingController _controllerEndereco = TextEditingController();
  TextEditingController _controllerQualValor = MoneyMaskedTextController(
      decimalSeparator: '.', thousandSeparator: ',', leftSymbol: 'R\$ ');
  TextEditingController _controllerQualDataFidelidade =
      MaskedTextController(mask: '00/00/0000');

  List<String> _simOuNao = ['Não Informado', 'Sim', 'Não'];
  List<String> _simOuNaoInt = [
    'Não Informado',
    'Sim',
    'Não',
    'Não Possui Internet'
  ];
  List<String> _qualPlanoVelocidades = [
    '1MB',
    '2MB',
    '3MB',
    '4MB',
    '5MB',
    '6MB',
    '7MB',
    '8MB',
    '10MB',
    '15MB',
    '30MB',
    '50MB',
    '100MB',
    'Outro Personalizado',
    'Não Possui Internet',
    'Não Informado'
  ];
  String _possuiInternetSelecionado;
  String _temFidelidade;
  String _qualPlano;
  String _mensagemErro = "";
  Position _stringPosition;
  bool _receberProposta = false;
  bool _estaSatisf = false;
  bool _interesseEmMudar = false;

  IconData _lLocal = Icons.location_off;

  bool dadosAdcionais = true;
  String adcRemovAdcionais = "Adcionar Mais Dados";

  bool possuiInternetDadosAdcionais = true;
  bool possuiFidelidadeDadosAdcionais = true;

  _validarCampos() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    print("asok");
    User usuarioLogado = await auth.currentUser;
    DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('usuarios').doc(usuarioLogado.uid).get();
    if(snapshot.data()["status"] == 'Tudo Certo'){

      //Recupera dados dos campos
      String nome = _controllerNome.text;
      String email = _controllerEmail.text;
      String telefone = _controllerTelefone.text;
      String endereco = _controllerEndereco.text;
      String localizacao = _stringPosition.toString();
      String localizacaoPrecisao;
      if(_stringPosition != null){
        localizacaoPrecisao = _stringPosition.accuracy.toString();
      }
      String possuiInternet = _possuiInternetSelecionado;
      String plano = _qualPlano;
      String valor = _controllerQualValor.text;
      String fidelidade = _temFidelidade;
      String dataFidelidade = _controllerQualDataFidelidade.text;
      bool receberProposta = _receberProposta;
      bool estaSatisfeito = _estaSatisf;
      bool interesseEmMudar = _interesseEmMudar;
      String vendedorEmail = usuarioLogado.email;
      String vendedorNome = snapshot.data()["nome"];

      if (nome.isNotEmpty) {
        if (telefone.isNotEmpty) {
          setState(() {
            _mensagemErro = "";
          });
          Cliente cliente = Cliente();
          cliente.nome = nome;
          cliente.email = email;
          cliente.telefone = telefone;
          cliente.endereco = endereco;
          cliente.localizacao = localizacao;
          cliente.localizacaoPrecisao = localizacaoPrecisao;
          cliente.possuiInternet = possuiInternet;
          cliente.qualPlano = plano;
          cliente.qualValor = valor;
          cliente.temFidelidade = fidelidade;
          cliente.quandAcabaFidelidade = dataFidelidade;
          cliente.interesseReceberProp = receberProposta;
          cliente.estaSatisf = estaSatisfeito;
          cliente.interesEmMudar = interesseEmMudar;
          cliente.vendedorEmail = vendedorEmail;
          cliente.vendedorNome = vendedorNome;
          _cadastrarUsuario(cliente);
        } else {
          setState(() {
            _mensagemErro = "Preencha o Telefone";
          });
        }
      } else {
        setState(() {
          _mensagemErro = "Preencha o Nome";
        });
      }
    }else{

      Scaffold.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.redAccent,
        content: Text("Usuário em análise ou não licenciado"),
      ));

    }


  }

  _cadastrarMaisDados() async {

    setState(() {
      if(dadosAdcionais == true){
        adcRemovAdcionais = "Remover Dados Extras";
        dadosAdcionais = false;
      }else{
        adcRemovAdcionais = "Adcionar Mais Dados";
        dadosAdcionais = true;
      }
    });
  }

  Future<void> _getCurrentLocation() async {
    _stringPosition = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best);

    if (_stringPosition.accuracy > 10) {
      Scaffold.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.redAccent,
        content: Text(
            "Precisão de ${_stringPosition.accuracy} Metros é muito ruim, tente novamente"),
      ));
      setState(() {
        _lLocal = Icons.location_searching;
      });
    } else {
      Scaffold.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.green,
        content: Text("Precisão de ${_stringPosition.accuracy} Metros"),
      ));
      setState(() {
        _lLocal = Icons.location_on;
      });
    }
  }

  _cadastrarUsuario(Cliente cliente) async {



    FirebaseAuth auth = FirebaseAuth.instance;
    User usuarioLogado = await auth.currentUser;
    var executaDados;
    String clinorImed = "clientes";
    //Salvar dados do usuario

    if(adcRemovAdcionais == "Adcionar Mais Dados"){

     executaDados = cliente.toMapSimple();
    }else{
      if (cliente.interesseReceberProp == true){
        clinorImed = "clientes imediato";
        if(cliente.temFidelidade == "Sim"){
          clinorImed = "clientes fidelidade";
        }
      }else {
        if(cliente.temFidelidade == "Sim"){
          clinorImed = "clientes fidelidade";
        }
      }
     executaDados = cliente.toMapAdvanced();
    }

    FirebaseFirestore db = FirebaseFirestore.instance;
    db
        .collection(clinorImed)
        .doc()
        .set(executaDados)
        .whenComplete(() {
          setState(() {
            _controllerNome.clear();
            _controllerEmail.clear();
            _controllerTelefone = MaskedTextController(mask: '(00) 00000-0000');
            _controllerEndereco.clear();
            _stringPosition = null;
            _lLocal = Icons.location_off;
            _possuiInternetSelecionado = null;
            _qualPlano = null;
            _controllerQualValor = MoneyMaskedTextController(
                decimalSeparator: '.', thousandSeparator: ',', leftSymbol: 'R\$ ');
            _temFidelidade = null;
            _controllerQualDataFidelidade = MaskedTextController(mask: '00/00/0000');
            _receberProposta = false;
            _estaSatisf = false;
            _interesseEmMudar = false;
          });
          Scaffold.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.green,
            content: Text("Cadastro Concluido Com Sucesso!"),
          ));
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil().setSp(28, allowFontScalingSelf: true);
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return Scaffold(
      body: Container(
          padding: EdgeInsets.all(ScreenUtil().setSp(16)),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                    bottom: ScreenUtil().setHeight(30),
                    top: ScreenUtil().setHeight(30),
                    left: ScreenUtil().setWidth(10),
                    right: ScreenUtil().setWidth(10),
                  ),
                  child: TextField(
                    controller: _controllerNome,
                    autofocus: false,
                    keyboardType: TextInputType.text,
                    style: TextStyle(fontSize: ScreenUtil().setSp(30)),
                    decoration: InputDecoration(
                        hintStyle: TextStyle(
                            color: Color.fromARGB(255, 13, 13, 115),
                            fontSize: ScreenUtil().setSp(30)),
                        contentPadding: EdgeInsets.fromLTRB(
                            ScreenUtil().setWidth(30),
                            ScreenUtil().setHeight(15),
                            ScreenUtil().setWidth(30),
                            ScreenUtil().setHeight(15)),
                        hintText: "Nome",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey, width: 0.0),
                            borderRadius: BorderRadius.circular(32))),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    bottom: ScreenUtil().setHeight(30),
                    top: ScreenUtil().setHeight(8),
                    left: ScreenUtil().setWidth(10),
                    right: ScreenUtil().setWidth(10),
                  ),
                  child: TextField(
                    controller: _controllerEmail,
                    autofocus: false,
                    keyboardType: TextInputType.emailAddress,
                    style: TextStyle(fontSize: ScreenUtil().setSp(30)),
                    decoration: InputDecoration(
                        hintStyle: TextStyle(
                            color: Color.fromARGB(255, 13, 13, 115),
                            fontSize: ScreenUtil().setSp(30)),
                        contentPadding: EdgeInsets.fromLTRB(
                            ScreenUtil().setWidth(30),
                            ScreenUtil().setHeight(15),
                            ScreenUtil().setWidth(30),
                            ScreenUtil().setHeight(15)),
                        hintText: "E-mail",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey, width: 0.0),
                            borderRadius: BorderRadius.circular(32))),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    bottom: ScreenUtil().setHeight(8),
                    top: ScreenUtil().setHeight(8),
                    left: ScreenUtil().setWidth(10),
                    right: ScreenUtil().setWidth(10),
                  ),
                  child: TextField(
                    controller: _controllerTelefone,
                    autofocus: false,
                    keyboardType: TextInputType.phone,
                    style: TextStyle(fontSize: ScreenUtil().setSp(30)),
                    decoration: InputDecoration(
                        hintStyle: TextStyle(
                            color: Color.fromARGB(255, 13, 13, 115),
                            fontSize: ScreenUtil().setSp(30)),
                        contentPadding: EdgeInsets.fromLTRB(
                            ScreenUtil().setWidth(30),
                            ScreenUtil().setHeight(15),
                            ScreenUtil().setWidth(30),
                            ScreenUtil().setHeight(15)),
                        hintText: "Telefone",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey, width: 0.0),
                            borderRadius: BorderRadius.circular(32))),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    bottom: ScreenUtil().setHeight(8),
                    top: ScreenUtil().setHeight(30),
                    left: ScreenUtil().setWidth(10),
                    right: ScreenUtil().setWidth(10),
                  ),
                  child: TextField(
                    controller: _controllerEndereco,
                    autofocus: false,
                    keyboardType: TextInputType.text,
                    style: TextStyle(fontSize: ScreenUtil().setSp(30)),
                    decoration: InputDecoration(
                        hintStyle: TextStyle(
                            color: Color.fromARGB(255, 13, 13, 115),
                            fontSize: ScreenUtil().setSp(30)),
                        contentPadding: EdgeInsets.fromLTRB(
                            ScreenUtil().setWidth(30),
                            ScreenUtil().setHeight(15),
                            ScreenUtil().setWidth(30),
                            ScreenUtil().setHeight(15)),
                        hintText: "Endereço",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey, width: 0.0),
                            borderRadius: BorderRadius.circular(32))),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 8.0),
                      child: FlatButton.icon(
                        onPressed: () => _getCurrentLocation(),
                        icon: Icon(
                          _lLocal,
                          color: Color.fromARGB(255, 13, 13, 115),
                        ),
                        label: Text(
                          'Pegar Localização',
                          style: TextStyle(
                              color: Color.fromARGB(255, 13, 13, 115),
                              fontSize: ScreenUtil().setSp(29)),
                        ),
                      ),
                    ),
                  ],
                ),

                Offstage(
                  offstage: dadosAdcionais,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                          bottom: ScreenUtil().setHeight(30),
                          top: ScreenUtil().setHeight(30),
                          left: ScreenUtil().setWidth(10),
                          right: ScreenUtil().setWidth(10),
                        ),
                        child: Container(
                          padding: EdgeInsets.only(
                            bottom: ScreenUtil().setHeight(0),
                            top: ScreenUtil().setHeight(0),
                            left: ScreenUtil().setWidth(10),
                            right: ScreenUtil().setWidth(10),
                          ),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(32.0)),
                              border: Border.all(color: Colors.grey, width: 1.0)),
                          child: Row(
                            children: <Widget>[
                              Padding(
                                  padding: EdgeInsets.only(
                                    bottom: ScreenUtil().setHeight(30),
                                    top: ScreenUtil().setHeight(30),
                                    left: ScreenUtil().setWidth(10),
                                    right: ScreenUtil().setWidth(10),
                                  ),
                                  child: Text(
                                    "Interesse em receber proposta?",
                                    style: TextStyle(
                                        color: Color.fromARGB(255, 13, 13, 115),
                                        fontSize: ScreenUtil().setSp(30)),
                                  )),
                              Container(
                                  padding: EdgeInsets.only(
                                    left: ScreenUtil().setWidth(70),
                                    right: ScreenUtil().setWidth(10),
                                  ),
                                  child: Checkbox(
                                    value: _receberProposta,
                                    onChanged: (newValue) {
                                      FocusScope.of(context).requestFocus(FocusNode());
                                      setState(() {
                                        _receberProposta = newValue;
                                      });
                                    },
                                  ))
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          bottom: ScreenUtil().setHeight(30),
                          top: ScreenUtil().setHeight(30),
                          left: ScreenUtil().setWidth(10),
                          right: ScreenUtil().setWidth(10),
                        ),
                        child: Container(
                          padding: EdgeInsets.only(
                            bottom: ScreenUtil().setHeight(0),
                            top: ScreenUtil().setHeight(0),
                            left: ScreenUtil().setWidth(10),
                            right: ScreenUtil().setWidth(10),
                          ),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(32.0)),
                              border: Border.all(color: Colors.grey, width: 1.0)),
                          child: Row(
                            children: <Widget>[
                              Padding(
                                  padding: EdgeInsets.only(
                                    bottom: ScreenUtil().setHeight(30),
                                    top: ScreenUtil().setHeight(30),
                                    left: ScreenUtil().setWidth(20),
                                    right: ScreenUtil().setWidth(10),
                                  ),
                                  child: Text(
                                    "Já Possui internet?",
                                    style: TextStyle(
                                        color: Color.fromARGB(255, 13, 13, 115),
                                        fontSize: ScreenUtil().setSp(30)),
                                  )),
                              Container(
                                padding: EdgeInsets.only(
                                  left: ScreenUtil().setWidth(30),
                                  right: ScreenUtil().setWidth(30),
                                ),
                                width: ScreenUtil().setWidth(380),
                                child: DropdownButton(
                                  isExpanded: true,
                                  icon: Icon(
                                    Icons.network_wifi,
                                    color: Color.fromARGB(255, 13, 13, 115),
                                  ),
                                  hint: Text(
                                    'Escolha uma opção',
                                    style: TextStyle(
                                        color: Color.fromARGB(255, 13, 13, 115),
                                        fontSize: ScreenUtil().setSp(30)),
                                  ),
                                  // Not necessary for Option 1
                                  value: _possuiInternetSelecionado,
                                  onChanged: (newValue) {
                                    FocusScope.of(context).requestFocus(FocusNode());
                                    setState(() {
                                      _possuiInternetSelecionado = newValue;
                                    });
                                    if (_possuiInternetSelecionado == 'Não') {
                                      setState(() {
                                        possuiInternetDadosAdcionais = true;
                                        _qualPlano = "Não Possui Internet";
                                      });
                                      setState(() {
                                        _temFidelidade = "Não Possui Internet";
                                      });
                                    }
                                    if (_possuiInternetSelecionado == 'Sim') {
                                      setState(() {
                                        possuiInternetDadosAdcionais = false;
                                      });
                                    }
                                  },
                                  items: _simOuNao.map((location) {
                                    return DropdownMenuItem(
                                      child: new Text(location),
                                      value: location,
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Offstage(
                        offstage: possuiInternetDadosAdcionais,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(
                                bottom: ScreenUtil().setHeight(30),
                                top: ScreenUtil().setHeight(30),
                                left: ScreenUtil().setWidth(10),
                                right: ScreenUtil().setWidth(10),
                              ),
                              child: Container(
                                padding: EdgeInsets.only(
                                  bottom: ScreenUtil().setHeight(0),
                                  top: ScreenUtil().setHeight(0),
                                  left: ScreenUtil().setWidth(10),
                                  right: ScreenUtil().setWidth(10),
                                ),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                                    border: Border.all(color: Colors.grey, width: 1.0)),
                                child: Row(
                                  children: <Widget>[
                                    Padding(
                                        padding: EdgeInsets.only(
                                          bottom: ScreenUtil().setHeight(30),
                                          top: ScreenUtil().setHeight(30),
                                          left: ScreenUtil().setWidth(20),
                                          right: ScreenUtil().setWidth(10),
                                        ),
                                        child: Text(
                                          "Qual Plano?",
                                          style: TextStyle(
                                              color: Color.fromARGB(255, 13, 13, 115),
                                              fontSize: ScreenUtil().setSp(30)),
                                        )),
                                    Container(
                                      margin:
                                      EdgeInsets.only(left: ScreenUtil().setWidth(90)),
                                      padding: EdgeInsets.only(
                                        left: ScreenUtil().setWidth(30),
                                        right: ScreenUtil().setWidth(30),
                                      ),
                                      width: ScreenUtil().setWidth(380),
                                      child: DropdownButton(
                                        isExpanded: true,
                                        icon: Icon(Icons.multiline_chart,
                                            color: Color.fromARGB(255, 13, 13, 115)),
                                        hint: Text(
                                          'Escolha uma opção',
                                          style: TextStyle(
                                              color: Color.fromARGB(255, 13, 13, 115),
                                              fontSize: ScreenUtil().setSp(30)),
                                        ),
                                        // Not necessary for Option 1
                                        value: _qualPlano,
                                        onChanged: (newValue) {
                                          FocusScope.of(context).requestFocus(FocusNode());
                                          setState(() {
                                            _qualPlano = newValue;
                                          });
                                          if (_possuiInternetSelecionado == "Sim") {
                                            if (_qualPlano == "Não Possui Internet") {
                                              Scaffold.of(context).showSnackBar(SnackBar(
                                                content: Text(
                                                    "Cliente possui internet! Opção invalida"),
                                              ));
                                              setState(() {
                                                _qualPlano = "Não Informado";
                                              });
                                            }
                                          }
                                          if (_possuiInternetSelecionado ==
                                              "Não Informado" ||
                                              _possuiInternetSelecionado == "Não") {
                                            if (_qualPlano != "Não Informado" ||
                                                _qualPlano != "Não Possui Internet") {
                                              setState(() {
                                                _possuiInternetSelecionado = "Sim";
                                              });
                                            }
                                          }
                                        },
                                        items: _qualPlanoVelocidades.map((location) {
                                          return DropdownMenuItem(
                                            child: new Text(location),
                                            value: location,
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            Padding(
                              padding: EdgeInsets.only(
                                bottom: ScreenUtil().setHeight(30),
                                top: ScreenUtil().setHeight(30),
                                left: ScreenUtil().setWidth(10),
                                right: ScreenUtil().setWidth(10),
                              ),
                              child: Container(
                                padding: EdgeInsets.only(
                                  bottom: ScreenUtil().setHeight(0),
                                  top: ScreenUtil().setHeight(0),
                                  left: ScreenUtil().setWidth(10),
                                  right: ScreenUtil().setWidth(10),
                                ),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                                    border: Border.all(color: Colors.grey, width: 1.0)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Padding(
                                        padding: EdgeInsets.only(
                                          bottom: ScreenUtil().setHeight(8),
                                          top: ScreenUtil().setHeight(8),
                                          left: ScreenUtil().setWidth(10),
                                          right: ScreenUtil().setWidth(50),
                                        ),
                                        child: Text(
                                          "Qual Valor?",
                                          style: TextStyle(
                                              color: Color.fromARGB(255, 13, 13, 115),
                                              fontSize: ScreenUtil().setSp(30)),
                                        )),
                                    Container(
                                      width: ScreenUtil().setWidth(430),
                                      height: ScreenUtil().setHeight(90),
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                          bottom: ScreenUtil().setHeight(8),
                                          top: ScreenUtil().setHeight(8),
                                          left: ScreenUtil().setWidth(70),
                                          right: ScreenUtil().setWidth(10),
                                        ),
                                        child: TextField(
                                          controller: _controllerQualValor,
                                          autofocus: false,
                                          keyboardType: TextInputType.number,
                                          style:
                                          TextStyle(fontSize: ScreenUtil().setSp(30)),
                                          decoration: InputDecoration(
                                              hintStyle: TextStyle(
                                                  color: Color.fromARGB(255, 13, 13, 115),
                                                  fontSize: ScreenUtil().setSp(30)),
                                              hintText: "Qual o Valor?",
                                              filled: true,
                                              fillColor: Colors.white),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),

                            Padding(
                              padding: EdgeInsets.only(
                                bottom: ScreenUtil().setHeight(30),
                                top: ScreenUtil().setHeight(30),
                                left: ScreenUtil().setWidth(10),
                                right: ScreenUtil().setWidth(10),
                              ),
                              child: Container(
                                padding: EdgeInsets.only(
                                  bottom: ScreenUtil().setHeight(0),
                                  top: ScreenUtil().setHeight(0),
                                  left: ScreenUtil().setWidth(10),
                                  right: ScreenUtil().setWidth(10),
                                ),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                                    border: Border.all(color: Colors.grey, width: 1.0)),
                                child: Row(
                                  children: <Widget>[
                                    Padding(
                                        padding: EdgeInsets.only(
                                          bottom: ScreenUtil().setHeight(30),
                                          top: ScreenUtil().setHeight(30),
                                          left: ScreenUtil().setWidth(10),
                                          right: ScreenUtil().setWidth(10),
                                        ),
                                        child: Text(
                                          "Esta satisfeito com seu plano atual?",
                                          style: TextStyle(
                                              color: Color.fromARGB(255, 13, 13, 115),
                                              fontSize: ScreenUtil().setSp(30)),
                                        )),
                                    Container(
                                        padding: EdgeInsets.only(
                                          left: ScreenUtil().setWidth(10),
                                          right: ScreenUtil().setWidth(10),
                                        ),
                                        child: Checkbox(
                                          value: _estaSatisf,
                                          onChanged: (newValue) {
                                            FocusScope.of(context).requestFocus(FocusNode());
                                            setState(() {
                                              if (_possuiInternetSelecionado == "Não") {
                                                _estaSatisf = false;
                                              } else {
                                                _estaSatisf = newValue;
                                              }
                                            });
                                          },
                                        ))
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                bottom: ScreenUtil().setHeight(30),
                                top: ScreenUtil().setHeight(30),
                                left: ScreenUtil().setWidth(10),
                                right: ScreenUtil().setWidth(10),
                              ),
                              child: Container(
                                padding: EdgeInsets.only(
                                  bottom: ScreenUtil().setHeight(0),
                                  top: ScreenUtil().setHeight(0),
                                  left: ScreenUtil().setWidth(10),
                                  right: ScreenUtil().setWidth(10),
                                ),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                                    border: Border.all(color: Colors.grey, width: 1.0)),
                                child: Row(
                                  children: <Widget>[
                                    Padding(
                                        padding: EdgeInsets.only(
                                          bottom: ScreenUtil().setHeight(30),
                                          top: ScreenUtil().setHeight(30),
                                          left: ScreenUtil().setWidth(20),
                                          right: ScreenUtil().setWidth(10),
                                        ),
                                        child: Text(
                                          "Tem Fidelidade?",
                                          style: TextStyle(
                                              color: Color.fromARGB(255, 13, 13, 115),
                                              fontSize: ScreenUtil().setSp(30)),
                                        )),
                                    Container(
                                      padding: EdgeInsets.only(
                                        left: ScreenUtil().setWidth(50),
                                        right: ScreenUtil().setWidth(10),
                                      ),
                                      width: ScreenUtil().setWidth(380),
                                      child: DropdownButton(
                                        isExpanded: true,
                                        icon: Icon(Icons.assignment_ind,
                                            color: Color.fromARGB(255, 13, 13, 115)),
                                        hint: Text(
                                          'Escolha uma opção',
                                          style: TextStyle(
                                              color: Color.fromARGB(255, 13, 13, 115),
                                              fontSize: ScreenUtil().setSp(30)),
                                        ),
                                        // Not necessary for Option 1
                                        value: _temFidelidade,
                                        onChanged: (newValue) {
                                          FocusScope.of(context).requestFocus(FocusNode());
                                          setState(() {
                                            _temFidelidade = newValue;
                                            if(_temFidelidade == "Sim"){
                                              possuiFidelidadeDadosAdcionais = false;
                                            }else{
                                              possuiFidelidadeDadosAdcionais = true;
                                            }
                                          });
                                        },
                                        items: _simOuNaoInt.map((location) {
                                          return DropdownMenuItem(
                                            child: new Text(location),
                                            value: location,
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Offstage(
                              offstage: possuiFidelidadeDadosAdcionais,
                              child: Padding(
                                padding: EdgeInsets.only(
                                  bottom: ScreenUtil().setHeight(30),
                                  top: ScreenUtil().setHeight(30),
                                  left: ScreenUtil().setWidth(10),
                                  right: ScreenUtil().setWidth(10),
                                ),
                                child: Container(
                                  padding: EdgeInsets.only(
                                    bottom: ScreenUtil().setHeight(0),
                                    top: ScreenUtil().setHeight(0),
                                    left: ScreenUtil().setWidth(10),
                                    right: ScreenUtil().setWidth(10),
                                  ),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(Radius.circular(32.0)),
                                      border: Border.all(color: Colors.grey, width: 1.0)),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Padding(
                                          padding: EdgeInsets.only(
                                            bottom: ScreenUtil().setHeight(8),
                                            top: ScreenUtil().setHeight(8),
                                            left: ScreenUtil().setWidth(10),
                                            right: ScreenUtil().setWidth(10),
                                          ),
                                          child: Text(
                                            "Quando acaba a fidelidade?",
                                            style: TextStyle(
                                                color: Color.fromARGB(255, 13, 13, 115),
                                                fontSize: ScreenUtil().setSp(30)),
                                          )),
                                      Container(
                                        width: ScreenUtil().setWidth(270),
                                        height: ScreenUtil().setHeight(90),
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                            bottom: ScreenUtil().setHeight(8),
                                            top: ScreenUtil().setHeight(8),
                                            left: ScreenUtil().setWidth(10),
                                            right: ScreenUtil().setWidth(10),
                                          ),
                                          child: TextField(
                                            controller: _controllerQualDataFidelidade,
                                            keyboardType: TextInputType.number,
                                            style:
                                            TextStyle(fontSize: ScreenUtil().setSp(30)),
                                            decoration: InputDecoration(
                                                hintStyle: TextStyle(
                                                    color: Color.fromARGB(255, 13, 13, 115),
                                                    fontSize: ScreenUtil().setSp(30)),
                                                hintText: "DD/MM/AAAA",
                                                filled: true,
                                                fillColor: Colors.white),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                bottom: ScreenUtil().setHeight(30),
                                top: ScreenUtil().setHeight(30),
                                left: ScreenUtil().setWidth(10),
                                right: ScreenUtil().setWidth(10),
                              ),
                              child: Container(
                                padding: EdgeInsets.only(
                                  bottom: ScreenUtil().setHeight(0),
                                  top: ScreenUtil().setHeight(0),
                                  left: ScreenUtil().setWidth(10),
                                  right: ScreenUtil().setWidth(10),
                                ),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                                    border: Border.all(color: Colors.grey, width: 1.0)),
                                child: Row(
                                  children: <Widget>[
                                    Padding(
                                        padding: EdgeInsets.only(
                                          bottom: ScreenUtil().setHeight(30),
                                          top: ScreenUtil().setHeight(30),
                                          left: ScreenUtil().setWidth(10),
                                          right: ScreenUtil().setWidth(10),
                                        ),
                                        child: Text(
                                          "Tem interesse em mudar?",
                                          style: TextStyle(
                                              color: Color.fromARGB(255, 13, 13, 115),
                                              fontSize: ScreenUtil().setSp(30)),
                                        )),
                                    Container(
                                        padding: EdgeInsets.only(
                                          left: ScreenUtil().setWidth(150),
                                          right: ScreenUtil().setWidth(10),
                                        ),
                                        child: Checkbox(
                                          value: _interesseEmMudar,
                                          onChanged: (newValue) {
                                            FocusScope.of(context).requestFocus(FocusNode());
                                            setState(() {
                                              _interesseEmMudar = newValue;
                                            });
                                          },
                                        ))
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),










                    ],

                    ///////////
                  )
                ),


                Padding(
                  padding: EdgeInsets.only(
                      top: ScreenUtil().setHeight(25),
                      bottom: ScreenUtil().setHeight(40)),
                  child: Container(
                    width: ScreenUtil().setWidth(750),
                    height: ScreenUtil().setHeight(80),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: ScreenUtil().setWidth(350),
                          child: Padding(
                              padding: EdgeInsets.only(
                                left: ScreenUtil().setWidth(10),
                                right: ScreenUtil().setWidth(10),
                              ),
                              child: RaisedButton(
                                child: Text(
                                  adcRemovAdcionais,
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 0, 71, 171),
                                      fontSize: ScreenUtil().setSp(25)),
                                ),
                                color: Colors.white,
                                padding: EdgeInsets.fromLTRB(
                                    ScreenUtil().setWidth(22),
                                    ScreenUtil().setHeight(16),
                                    ScreenUtil().setWidth(22),
                                    ScreenUtil().setHeight(16)),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(32),side: BorderSide(color: Color.fromARGB(255, 0, 71, 171))),
                                onPressed: () {
                                  _cadastrarMaisDados();

                                },
                              )),
                        ),



                        Container(
                          width: ScreenUtil().setWidth(350),
                          child: Padding(
                              padding: EdgeInsets.only(
                                left: ScreenUtil().setWidth(10),
                                right: ScreenUtil().setWidth(10),
                              ),
                              child: RaisedButton(
                                child: Text(
                                  "Cadastrar",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: ScreenUtil().setSp(25)),
                                ),
                                color: Color.fromARGB(255, 0, 71, 171),
                                padding: EdgeInsets.fromLTRB(
                                    ScreenUtil().setWidth(22),
                                    ScreenUtil().setHeight(16),
                                    ScreenUtil().setWidth(22),
                                    ScreenUtil().setHeight(16)),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(32)),
                                onPressed: () {
                                  _validarCampos();
                                },
                              )
                          ),
                        )
                      ],
                    )
                  ),
                ),
                Text(
                  _mensagemErro,
                  style: TextStyle(
                      color: Colors.red, fontSize: ScreenUtil().setSp(25)),
                )
              ],
            ),
          )),
    );
  }

}
