import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:parla_italiano/globals/appBar.dart';
import 'package:parla_italiano/widgets.dart';
import 'package:parla_italiano/globals/vocabularyRepository.dart' as repository;
import 'package:parla_italiano/globals/navigationBar.dart';


class VocabularyDetailsScreen extends StatefulWidget {
  String? tablename;
  String? table_id;
  VocabularyDetailsScreen({super.key, this.tablename, this.table_id});
  

  @override
  VocabularyDetailsScreenState createState() => VocabularyDetailsScreenState(table_id: table_id, tablename: tablename);
}

class VocabularyDetailsScreenState extends State<VocabularyDetailsScreen> {

  String? table_id;
  String? tablename;
  VocabularyDetailsScreenState({required this.table_id, required this.tablename});
  List<repository.Vocabulary> vocabularylist = [];
  

  @override
  Widget build(BuildContext context){
    return PopScope(
    canPop: false,
    child: Scaffold(
      bottomNavigationBar: CustomNavigationBar(),
      appBar: CustomAppBar(),
        body: Container(
          decoration: new BoxDecoration(
            color: Colors.purple,
            gradient: new LinearGradient(
              colors: [Colors.green, Colors.white, Colors.red],
              //begin: Alignment.topLeft,
              //end: Alignment.topRight,
            ),
          ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 32),
          child:
            Column(
              children: [
                const SizedBox(height: 10),
                Row(children: [
                        Expanded(
                          flex: 15,
                          child: Center(                   
                            child: Text(
                              '${widget.tablename}',
                              style: TextStyle(
                                fontSize: 26,
                                color: Colors.black87,
                              )
                            ),
                          ),
                        ),
                ],
                mainAxisAlignment: MainAxisAlignment.center,),
                const SizedBox(height: 10),
                const Divider(
                  color: Colors.black
                ),
                const SizedBox(height: 10),
                VocabularyListTileWidget(),
                const Divider(
                  color: Colors.black,
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: this._getAllVocabularies().length,
                    itemBuilder: (context, index){
                      return VocabularyWidget(_getAllVocabularies()[index].id, _getAllVocabularies()[index].italian, _getAllVocabularies()[index].german, _getAllVocabularies()[index].additional)      
                      ;
                    }
                  )
                ),
                const SizedBox(height: 20),
              ],
            )
        )
      )
    )
  
    );

   
  } 

  List<repository.Vocabulary> _getAllVocabularies(){
    for (repository.VocabularyTable table in repository.vocabularyTables){
      if (table.db_id == table_id || table.title == tablename){
        return  table.vocabularies;
      }
    }
    if (table_id == '0'){
      return repository.favouritesTable.vocabularies;
    }
    return [];
  }
}