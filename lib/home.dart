import "package:flutter/material.dart";
import 'package:todoappwithriverpod/taskspage.dart';
import 'package:todoappwithriverpod/donetaskspage.dart';
import "package:intl/intl.dart";
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'RiverPodProviders.dart';
import "package:flutter_spinkit/flutter_spinkit.dart";

//DATABASE STEPS
//1-create database by opening for creation
//2-create tables
//3-open database
//4-insert into database
//5-read from database
//6-update database
//7-delete from database

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  List<Widget> pages = [NewTasksScreen(), DoneTasksScreen(),];
  int navigatIndex=0;
  var formkey = GlobalKey<FormState>();
  String? textfieldtask;
  var timecontroller = TextEditingController();
  var datecontroller = TextEditingController();
  Future? dataReceived;



 @override
 void initState() {
   super.initState();
   dataReceived = context.read(tasksDataProvider).createDatabase();

 }


  @override
  Widget build(BuildContext context) {

    print("build called");
    void bottomsheet() {
      showModalBottomSheet(isScrollControlled: true, context: context, builder:
          (context) {
        return
          Form(key: formkey,
            child: Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery
                      .of(context)
                      .viewInsets
                      .bottom),
              child: Column(mainAxisSize: MainAxisSize.min,
                children: [TextFormField(keyboardType: TextInputType.text,
                  decoration: InputDecoration(hintText: "Enter Task Title",
                      fillColor: Colors.grey[200],
                      filled: true,
                      prefixIcon: Icon(Icons.title_sharp),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blueAccent,
                              width: 3)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blueAccent,
                              width: 3))
                  ),
                  validator: (val) =>
                  (val!.isEmpty)
                      ? ("Don't leave this field empty!")
                      : null,
                  onChanged: (val) {
                    textfieldtask = val;
                  },
                ),
                  SizedBox(height: 15),
                  TextFormField(
                    controller: timecontroller
                    ,
                    keyboardType: TextInputType.datetime,
                    decoration: InputDecoration(
                      hintText: "Enter Task Time",
                      fillColor: Colors.grey[200],
                      filled: true,
                      prefixIcon: Icon(Icons.access_alarm_outlined),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blueAccent,
                              width: 3)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blueAccent,
                              width: 3)),
                    ),
                    validator: (val) =>
                    (val!.isEmpty)
                        ? ("Don't leave this field empty!")
                        : null,
                    onTap: () async {
                      var time = await showTimePicker(
                          context: context, initialTime: TimeOfDay.now());
                      timecontroller.text = time!.format(context).toString();
                    },

                  ),
                  SizedBox(height: 15),
                  TextFormField(
                    controller: datecontroller,
                    keyboardType: TextInputType.datetime,
                    decoration: InputDecoration(
                      hintText: "Enter Task Date",
                      fillColor: Colors.grey[200],
                      filled: true,
                      prefixIcon: Icon(Icons.calendar_today_outlined),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blueAccent,
                              width: 3)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blueAccent,
                              width: 3)),
                    ),
                    validator: (val) =>
                    (val!.isEmpty)
                        ? ("Don't leave this field empty!")
                        : null,
                    onTap: () async
                    {
                      var date = await showDatePicker(context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime.parse("2021-12-31"));
                      datecontroller.text = DateFormat.yMMMd().format(date!);
                    },


                  ),
                  ElevatedButton(child: Text("SUBMIT",
                      style: TextStyle(color: Colors.indigo, fontSize: 15)),
                    style: ElevatedButton.styleFrom(primary: Colors.blue),
                    onPressed: () async {
                      if (formkey.currentState!.validate()) {
                        context.read(tasksDataProvider).insertToDatabase(tablename:"TASKS",title: textfieldtask,
                            time: timecontroller.text,
                            date: datecontroller.text);

                        Navigator.pop(context);

                      }
                    },)
                ],
              ),
            ),


          );
      });
    }
    List floatingButtons=[FloatingActionButton(backgroundColor: Colors.blueAccent,
      onPressed: () {
        bottomsheet();
      },
      child: Icon(Icons.add,),

    ),null];

    return Scaffold(
        resizeToAvoidBottomInset: false,
        /*WE WANT TO GET THE DATA FROM DATABASE ONLY ONCE
        SO WE USE A COUNTER SO THE FUTURE BUILDER ONLY CALLED ONCE

         */
        body:SafeArea(child:FutureBuilder(
        future:dataReceived,
        builder:(context,snapshot){if(snapshot.connectionState==ConnectionState.done){
      return pages[navigatIndex];
    }
    else if(snapshot.hasError){return Center(child:Text("ERROR GETTING DATA"));}
    else{ return Center(child:SpinKitRing(color:Colors.blue,size:50));}
    })),
        floatingActionButton: floatingButtons[navigatIndex],
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,


        bottomNavigationBar: BottomNavigationBar(
          items: [BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            label: "Tasks",

          ),
            BottomNavigationBarItem(
                icon: Icon(Icons.check_circle_outline),
                label: "done",
              
            )

          ],
          type: BottomNavigationBarType.fixed,
          currentIndex:navigatIndex,
          onTap: (index) {
            setState(() {
              navigatIndex=index;
            });
          },)


    );
  }
  @override
  void dispose(){
    //YOU MUST DISPOSE CONTROLLERS
    timecontroller.dispose();
    datecontroller.dispose();
    super.dispose();
  }
}
