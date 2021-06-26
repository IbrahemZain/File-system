import 'package:flutter/material.dart';
import 'fileUtils.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String fileContents = "No Data";
  final myController = TextEditingController();

  //local notifications
  FlutterLocalNotificationsPlugin flutterNotification;


  @override
  void initState() async{
    super.initState();

    //local notifications
    var androidInitialize = new AndroidInitializationSettings('app_icon');
    var iOSInitialize = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        android: androidInitialize, iOS: iOSInitialize);
    flutterNotification = new FlutterLocalNotificationsPlugin();
    flutterNotification.initialize(initializationSettings,
        onSelectNotification: localNotificationSelected);
  }

  Future _showLocalNotification() async {
    var androidDetails = new AndroidNotificationDetails(
        "Channel ID", "Desi programmer", "This is my channel",
        importance: Importance.max);
    var iSODetails = new IOSNotificationDetails();
    var generalNotificationDetails =
        new NotificationDetails(android: androidDetails, iOS: iSODetails);

    // await flutterNotification.show(
    //     0, "Note", "You save the text: "+ fileContents,
    //     generalNotificationDetails, payload: "Greate");

    var scheduledTime = DateTime.now().add(Duration(seconds: 10));
    await flutterNotification.schedule(
        0,
        "Note",
        "You save the text: " + fileContents,
        scheduledTime,
        generalNotificationDetails,
        payload: "Greate");
  }

  Future localNotificationSelected(String payload) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text("Notification : $payload"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("File System"),
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: myController,
              ),
            ),
            RaisedButton(
              onPressed: () {
                FileUtils.saveToFile(myController.text);
              },
              child: Text('Save To File'),
            ),
            RaisedButton(
              onPressed: () {
                FileUtils.readFromFile().then((contents) {
                  setState(() {
                    fileContents = contents;
                  });
                });
              },
              child: Text('Raed from the File'),
            ),
            Text(fileContents),
            SizedBox(
              height: 20,
            ),
            RaisedButton(
              onPressed: _showLocalNotification,
              child: Text('The Notifications'),
            ),
          ],
        ),
      ),
    );
  }
}
