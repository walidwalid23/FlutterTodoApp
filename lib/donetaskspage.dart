import 'package:flutter/material.dart';
import 'package:todoappwithriverpod/RiverPodProviders.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DoneTasksScreen extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    print("IN RIVERPOD OUT OF CONSUMER BUILT DONETASKS PAGE");
    return Column(mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("FINISHED TASKS",style:TextStyle(color:Colors.white,fontSize: 30,fontWeight:FontWeight.w700)),

        SizedBox(height:20),
        Icon(Icons.done_outline_outlined,size:80,color:Colors.green),
        SizedBox(height:30),
        Expanded(
          child: Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(35),color: Colors.white),
              child:Consumer(builder:(context,watch,child){
                print("IN RIVERPOD INSIDE CONSUMER BUILT DONETASKS PAGE");
                var donetasks=watch(tasksDataProvider).donetasks;
                return ListView.builder(itemCount: watch(tasksDataProvider).donetasks?.length??0,
                  itemBuilder:(context,index){
                    return
                      Dismissible(
                        direction: DismissDirection.endToStart,
                        background:Container(color:Colors.red[900],child:Icon(Icons.dangerous,color: Colors.red[200],size:70)),
                        onDismissed: (direction) {
                          if (direction == DismissDirection.endToStart) {
                            context.read(tasksDataProvider).deleteDataFromDoneTasksTable(title: donetasks?[index]["TITLE"], time: donetasks?[index]["TIME"], date: donetasks?[index]["DATE"]);
                          }
                        } ,
                        key:ValueKey(donetasks![index]),
                        child: Card(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
                            child:ListTile(leading: CircleAvatar(radius:33,backgroundColor:Colors.blue[300],
                              child: Column(mainAxisAlignment: MainAxisAlignment.center,children:[ Text("Task",style:TextStyle(fontSize: 17,color:Colors.indigo))
                                ,Text("${index+1}",style:TextStyle(fontSize: 15,color:Colors.indigo))]),),
                              title: Text("${ donetasks[index]["TITLE"]}",style:TextStyle(color:Colors.orange,fontSize: 18),),
                              subtitle:Text("${ donetasks[index]["DATE"]}",style:TextStyle(color:Colors.amber,fontSize: 18),) ,
                              trailing: Text("${ donetasks[index]["TIME"]}",style:TextStyle(color:Colors.lime),),)


                        ),
                      );

                  } ,scrollDirection:Axis.vertical,);}
              )),
        ),
      ],
    );}

}

