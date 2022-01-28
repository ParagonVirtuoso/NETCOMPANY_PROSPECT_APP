import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class OnuData{
  String id;
  bool unlock;
  bool falha;
  String EquipmentID;
  String TecSolicitante;
  String FSP;
  List OntSN;
  String onuid;
  String alias;
  List images;
  String tipo;
  var dataDesbloqueio;


  OnuData.fromDocument(DocumentSnapshot snapshot){
    id = snapshot.id;
    EquipmentID = snapshot.data()["EquipmentID"];
    FSP = snapshot.data()["F/S/P"];
    OntSN = snapshot.data()["Ont SN"];
    onuid = snapshot.data()["ont_id"];
    images = snapshot.data()["images"];
    alias = snapshot.data()["Alias"];
    unlock = snapshot.data()["Aunlock"];
    falha = snapshot.data()["Falha"];
    TecSolicitante = snapshot.data()["TecSolicitante"];
    dataDesbloqueio = snapshot.data()["DataUnlock"];
    tipo = snapshot.data()["Tipo"];

    if(onuid == null){
      onuid = "Informação Indisponivel";
    }
    if(dataDesbloqueio == null){
      dataDesbloqueio = "Informação Indisponivel";
    }else{
      dataDesbloqueio = dataDesbloqueio.toDate();
      dataDesbloqueio = DateFormat("dd/MM/yyyy H:mm").format(dataDesbloqueio);
    }
  }

  Map<String, dynamic> toResumedMap(){
    return {
      "Alias": alias,
      "Aunlock": unlock,
      "Falha": falha,
      "EquipmentID": EquipmentID,
      "F/S/P": FSP,
      "Ont SN": OntSN,
      "images" : images,
      "ont_id": onuid,
      "DataUnlock": dataDesbloqueio,
      "TecSolicitante": TecSolicitante,
      "Tipo": tipo
    };
  }

  Map<String, dynamic> resAliasToMap(){
    return {
      "Alias": alias,
      "TecSolicitante": TecSolicitante,
      "Tipo": tipo
    };
  }

}