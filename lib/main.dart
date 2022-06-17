import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
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

  FirebaseMessaging messaging = FirebaseMessaging.instance;
  //

  @override
  void initState() {
    super.initState();
    // //

    firebaseRequestPermission();
    firebaseSetupListener();

    //
    // onMessage = will be triggered while notif is received while app is opened/active
    // messaging.configure(onMessage: (message) async {
    //   debugPrint("isi message yang diterima pada ${waktu}");
    //   debugPrint(message.toString());
    //   //
    //   setState(() {
    //     messageTitle = message["notification"]["title"];
    //     notificationAlert = "New Notif Alert!";
    //   });
    // },
    //     //onResume will be triggered while we receive the notification alert in the device notification bar
    //     //and opens the app through the push notification itself.
    //     onResume: (message) {
    //   debugPrint("isi message yang diterima");
    //   debugPrint(message.toString());
    //   setState(() {
    //     //
    //     messageTitle = message["data"]["title"];
    //     notificationAlert = "App opened from notip";
    //   });
    // });
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

  firebaseSetupListener() {
    String waktu = DateFormat("HH:mm").format(DateTime.now());

    FirebaseMessaging.onMessage.listen((RemoteMessage notif) {
      debugPrint("isi notif yang diterima pada ${waktu}");
      debugPrint(notif.toString());
      debugPrint(notif.notification.toString());
      debugPrint(notif.notification.title);
      //
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
