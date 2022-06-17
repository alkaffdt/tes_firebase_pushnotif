import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String messageTitle = "empty";
  String notificationAlert = "alert";
  //
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  //
  var localNotif = FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    // //

    firebaseRequestPermission();
    firebaseSetupListener();
  }

  firebaseRequestPermission() async {
    messaging.setAutoInitEnabled(true);
    //
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }

  firebaseSetupListener() async {
    String waktu = DateFormat("HH:mm").format(DateTime.now());

    FirebaseMessaging.onMessage.listen((RemoteMessage notif) async {
      debugPrint("isi notif yang diterima pada ${waktu}");
      debugPrint(notif.toString());
      debugPrint(notif.notification.toString());
      debugPrint(notif.notification.title);
      //
      await localNotif.show(
          0,
          notif.notification.title,
          notif.notification.body,
          NotificationDetails(iOS: IOSNotificationDetails()));
      setState(() {
        messageTitle = notif.notification.title;
        notificationAlert = "New Notif Alert!";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(notificationAlert),
          Text(messageTitle, style: Theme.of(context).textTheme.headline4)
        ],
      ),
    )));
  }
}
