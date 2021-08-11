import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todoappwithriverpod/RiverPodProviders.dart';


class NewTasksScreen extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    print("IN RIVERPOD OUT OF CONSUMER BUILT TASKS PAGE");
    return Column(mainAxisAlignment: MainAxisAlignment.center,
      children: [Text("My Tasks",style:TextStyle(color:Colors.white,fontSize: 30,fontWeight:FontWeight.w700)),
        SizedBox(height:20),
        Icon(Icons.home_sharp,size:80,color:Colors.amber),
        SizedBox(height:30),
        Expanded(
          child: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(35),color: Colors.white),
            child: Consumer(builder:(context,watch,child){
              print("IN RIVERPOD INSIDE CONSUMER BUILT TASKS PAGE");
              var tasks=watch(tasksDataProvider).tasks;
              return  ListView.builder(itemCount:watch(tasksDataProvider).tasks?.length??0,
                itemBuilder:(context,index){
                  return
                    Dismissible(
                      //WE NEED A UNIQUE KEY FOR EACH OBJECT SO I JUST GAVE THE OBJECT ITSELF AS THE KEY
                      key:ValueKey(tasks![index]),
                      onDismissed: (direction){

                        if(direction==DismissDirection.startToEnd)  {
                          //DONE TASKS
                          context.read(tasksDataProvider).insertIntoDoneTasksTable(title:tasks[index]["title"], time:tasks[index]["time"],date:tasks[index]["date"]);
                        }
                        if(direction==DismissDirection.endToStart)  {
                          //DELETE TASK
                          context.read(tasksDataProvider).deleteDataFromTasksTable(title:tasks[index]["title"], time:tasks[index]["time"],date:tasks[index]["date"]);}
                      },
                      //start to end background
                      background: Container(color:Colors.green[800],child:Icon(Icons.done_outline_outlined,color: Colors.green[200],size:70)),
                      //end to start background
                      secondaryBackground: Container(color:Colors.red[900],child:Icon(Icons.dangerous,color: Colors.red[200],size:70)),

                      child: Card(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
                          child:ListTile(leading: CircleAvatar(radius:33,backgroundColor:Colors.blue[300],
                            child: Column(mainAxisAlignment: MainAxisAlignment.center,children:[ Text("Task",style:TextStyle(fontSize: 17,color:Colors.indigo))
                              ,Text("${index+1}",style:TextStyle(fontSize: 15,color:Colors.indigo))]),),
                            title: Text("${ tasks[index]["title"]}",style:TextStyle(color:Colors.orange,fontSize: 18),),
                            subtitle:Text("${ tasks[index]["date"]}",style:TextStyle(color:Colors.amber,fontSize: 18),) ,
                            trailing: Text("${ tasks[index]["time"]}",style:TextStyle(color:Colors.lime),),)

                      ),
                    );

                } ,scrollDirection:Axis.vertical,);},
            ),
          ),
        ),
      ],
    );}

}

