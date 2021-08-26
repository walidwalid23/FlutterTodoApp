import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class ListenedData extends ChangeNotifier{

  // TASKS DATA AND FUNCTIONS
  List<Map>? tasks;
  List<Map>? donetasks;
  Database? database;

  Future<void> createDatabase() async{
    try {
      database= await openDatabase("todo.db",
          version: 1,
          onCreate: (database, version) async {
            //THIS WON'T BE CALLED if DATABASE ALREADY CREATED
            //  (title,date,time,status)
            database.execute('CREATE TABLE TASKS(title varchar(150),time varchar(40),date varchar(50))');
            database.execute('CREATE TABLE DONETASKS(TITLE varchar(150),TIME varchar(40),DATE varchar(50))');
            print("database created");
          },
          onOpen: (database)  async{
        /*IT GIVES US A SAME DATABASE OBJECT THAT WE CAN
          USE BEFORE THE ORIGINAL DATABASE OBJECT
          IS RETURNED IF NEEDED*/
          });

      print("db opened");
      tasks=await getDataFromDB(database,tablename: "TASKS");
      donetasks=await getDataFromDB(database,tablename: "DONETASKS");
      notifyListeners();
      //DELAYING A BIT TO TEST THE LOADING
      await Future.delayed(Duration(seconds:2));


    }
    catch(error){print("ERROR OCCURED:$error");
   }
  }


  Future getDataFromDB(openeddatabase,{@required String? tablename}) async{
    try{

      List<Map> dbtasks=await openeddatabase!.rawQuery('SELECT* FROM ${tablename}');
      return dbtasks;

    }
    catch(error){print("erorr is:$error");}
  }

  Future<void> deleteDataFromTasksTable({@required String? title,@required String? time,@required String? date} ) async{

    int count=await database!.rawDelete('DELETE FROM TASKS WHERE TITLE="$title" AND TIME="$time" AND DATE="$date"');

    tasks=await getDataFromDB(database,tablename: "TASKS");
    notifyListeners();

  }
  Future<void> insertToDatabase({@required String? tablename,@required String? title,@required String? time,@required String? date }) async{
    try{
      await database!.transaction((txn) async {
        int tottalrowsintable = await txn.rawInsert(
            'INSERT INTO ${tablename} VALUES("$title","$time","$date")');
        print("inserted succeffully number of row inserts:$tottalrowsintable");
      });


      tasks=await getDataFromDB(database,tablename: tablename);
      notifyListeners();

    }

    catch(error){print("error occured when inserting:$error");}

  }

  Future<void> insertIntoDoneTasksTable({@required String? title,@required String? time,@required String? date}) async{
    //INSERTING THE FINISHED TASKS INTO THE DONETASKS TABLE
    await database!.transaction((txn) async{

      await txn.rawInsert('INSERT INTO DONETASKS VALUES("$title","$date","$time")');
      print("inserted INTO DONE TASKS SUCCEFFULLY");
    }

    );

    donetasks=await getDataFromDB(database, tablename:"DONETASKS");
    print("THE DATA IN DONETASKS ARE ${donetasks}");

    //DELETING THE FINISHED TASKS FROM THE TASK TABLE
    deleteDataFromTasksTable( title:title,time:time,date:date );

    notifyListeners();
  }
  Future<void> deleteDataFromDoneTasksTable({@required String? title,@required String? time,@required String? date} ) async{

    int count=await database!.rawDelete('DELETE FROM DONETASKS WHERE TITLE="$title" AND TIME="$time" AND DATE="$date"');

    donetasks=await getDataFromDB(database,tablename: "DONETASKS");
    notifyListeners();

  }

}




