import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:parla_italiano/dbModels/DBtable.dart';
import 'package:parla_italiano/dbModels/DBvocabulary.dart';
import 'package:flutter/material.dart';

import 'package:parla_italiano/models/vocabulary.dart';
import 'package:parla_italiano/models/vocabularyTable.dart';
import 'package:parla_italiano/globals/globalData.dart' as globalData;

class VocabularyHandler {

  VocabularyHandler();

  List<VocabularyTable> startConfiguration(List<DBVocabulary> dbVocabularies, List<DBTables> dbTables){
    List<VocabularyTable> vocabularyTables = [];
    for (DBTables table in dbTables){
      VocabularyTable newTable = VocabularyTable(table.title, table.level, table.id);
      vocabularyTables.add(newTable);
    }
    for (DBVocabulary vocabulary in dbVocabularies){
      Vocabulary newVocabulary = Vocabulary(vocabulary.german, vocabulary.italian, vocabulary.additional, vocabulary.id);
      for (VocabularyTable table in vocabularyTables){
        if (table.db_id == vocabulary.table_id){
          table.addVocabulary(newVocabulary);
          break;
        }
      }
    }
    vocabularyTables.sort((a, b) => a.level.compareTo(b.level));
    return vocabularyTables;
  }

  deleteVocabularyIdsByTableId(String tableId, List<DBVocabulary> vocabularylist){
    for (DBVocabulary vocabulary in vocabularylist){
      if (vocabulary.table_id == tableId){
        final docUser = FirebaseFirestore.instance
          .collection('vocabularies')
          .doc(vocabulary.id);
        docUser.delete();
      }
    }
  }

  Stream<List<DBVocabulary>> readVocabularies() => FirebaseFirestore.instance
    .collection('vocabularies')
    .snapshots()
    .map((snapshot) => snapshot.docs.map((doc) => DBVocabulary.fromJson(doc)).toList());

  Widget buildTables(DBTables table) => ListTile(
    leading: CircleAvatar(child:Text('${table.level}')),
    title: Text(table.title));

  Stream<List<DBTables>> readTables() => FirebaseFirestore.instance
    .collection('tables')
    .snapshots()
    .map((snapshot) => snapshot.docs.map((doc) => DBTables.fromJson(doc)).toList());

  Future createTable({required String title, required int level}) async{
    var tables = FirebaseFirestore.instance.collection('tables').doc();
    final json = {
            'title': title,
            'level': level,
          };
    await tables.set(json);
  }

  Future createVocabulary({required String italian, required String german, required String additonal, required String id}) async{
    var vocabularies = FirebaseFirestore.instance.collection('vocabularies').doc();
    final json = {
            'italian': italian,
            'german': german,
            'additional': additonal,
            'table_id': id,
          };
    await vocabularies.set(json);
  }

  int calculateAmounts(String tableId, List<DBVocabulary> vocabularylist){
    int amount = 0;
    for (DBVocabulary vocabulary in vocabularylist){
      if (vocabulary.table_id == tableId){
        amount = amount + 1;
      }
    }
    return amount;
  }

  List<Vocabulary> getAllVocabularies(String table_id, String tablename){
    for (VocabularyTable table in globalData.vocabularyRepo!.vocabularyTables){
      if (table.db_id == table_id || table.title == tablename){
        return  table.vocabularies;
      }
    }
    if (table_id == '0'){
      return globalData.vocabularyRepo!.favouritesTable.vocabularies;
    }
    return [];
  }
  
}
