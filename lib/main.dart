import 'package:flutter/material.dart';
import './notification_helper.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as dtp;
import 'package:timezone/timezone.dart' as tz;
import './new_task.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; // Needed for encoding/decoding JSON

main() {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationHelper.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData.dark(),
      home: const MyHomePage(),
    );
  }
}


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key,});
  // final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
   List<Map<String, String>> _tasks = [];

  TextEditingController description = TextEditingController();
  TextEditingController dateOfEvent = TextEditingController();
  TextEditingController reminderDate = TextEditingController();

  void _addTask() {
    setState(() {
      _tasks.add({
        'sno': (_tasks.length + 1).toString().padLeft(2, '0'),
        'description': description.text,
        'dateOfEvent': dateOfEvent.text,
        'reminderDate': reminderDate.text,
      });
       _saveTasks();
    });

    // // Schedule the notification
    // _scheduleNotification(description.text, reminderDate.text);

    description.clear();
    dateOfEvent.clear();
    reminderDate.clear();
  }

  void _deleteTask(int index) {
    setState(() {
      _tasks.removeAt(index);
      for (int i = 0; i < _tasks.length; i++) {
        _tasks[i]['sno'] = (i + 1).toString().padLeft(2, '0');
      }
       _saveTasks();
    });
  }

void _saveTasks() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('tasks', json.encode(_tasks));
}

  @override
void initState() {
  super.initState();
  _loadTasks();
}

void _loadTasks() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? tasksString = prefs.getString('tasks');
  if (tasksString != null) {
    setState(() {
      _tasks = List<Map<String, String>>.from(json.decode(tasksString));
    });
  }
}


  
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      // backgroundColor: Colors.amber,
      appBar: AppBar(
        // backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // backgroundColor: Colors.black,
        title: const Text("Task Wave",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Card(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    "S.No.",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Desc.",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Reminder Date",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Del",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            // const SizedBox(
            //   height: 110,
            // ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _tasks.length,
              itemBuilder: (context, index) {
                return NewTask(
                  sno: _tasks[index]['sno']!,
                  description: _tasks[index]['description']!,
                  dateOfEvent: _tasks[index]['dateOfEvent']!,
                  reminderDate: _tasks[index]['reminderDate']!,
                  onDelete: () => _deleteTask(index),
                );
              },
            ),
            TextField(
              controller: description,
              style: const TextStyle(color: Colors.black),
              decoration: const InputDecoration(
                hintText: "Please enter the description of the task",
                hintStyle: TextStyle(
                    color: Colors.black, fontWeight: FontWeight.normal),
                prefixIcon: Icon(Icons.task),
                prefixIconColor: Colors.black,
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              controller: reminderDate,
              style: const TextStyle(color: Colors.black),
              decoration: const InputDecoration(
                hintText: "Please enter reminder date",
                hintStyle: TextStyle(
                    color: Colors.black, fontWeight: FontWeight.normal),
                prefixIcon: Icon(Icons.task),
                prefixIconColor: Colors.black,
                filled: true,
                fillColor: Colors.white,
              ),
            ),
        
            const SizedBox(height: 20,),
            
            ElevatedButton(
              onPressed: () {
                dtp.DatePicker.showDateTimePicker(
                  context,
                  showTitleActions: true,
                  onChanged: (time) {},
                  onConfirm: (time) {
                    sheduleTime = tz.TZDateTime.from(time, tz.local);
                  },
                );
              },
              child: const Text("Set Reminder date and time"),
            ),
            ElevatedButton(
              onPressed: () {
                NotificationHelper.scheduleNotification(
                  description.text,
                  "Notify Me",
                  3,
                );
                showDialog(context: context, builder: (BuildContext context){
                        return const AlertDialog(
                          title: Text('Popup'),
                          content: Text("Notification Scheduled"),
                        );
                });
              },
              
              child: const Text("Set Notification"),
            ),
            // ElevatedButton(
            //   onPressed: () {
            //     NotificationHelper().cancelAllNotifications();
            //   },
            //   child: const Text("Remove Notification"),
            // ),
            ElevatedButton(
              onPressed: (){
                _addTask();
                showDialog(context: context, builder: (BuildContext context){
                        return const AlertDialog(
                          title: Text("Popup"),
                          content: Text("Task Added"),
                        );
                });
              },
              
              child: const Text("Add Task"),
            )
          ],
        ),
      ),
    );
  }
}
