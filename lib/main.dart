import 'package:aktuel/AdmobService.dart';
import 'package:aktuel/Bloc/favori_bloc.dart';
import 'package:aktuel/Bloc/takip_bloc.dart';
import 'package:aktuel/Widgets/bottom_navbar.dart';
import 'package:aktuel/Widgets/push_notifacation.dart';
import 'package:aktuel/locator.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'Bloc/kategori_bloc.dart';
import 'Bloc/urun_bloc.dart';
void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseAdMob.instance.initialize(appId: AdmobService().getAdMobId());
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'E-Aktuel',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    keywords: <String>['flutterio', 'beautiful apps'],
    contentUrl: 'https://flutter.io',
    birthday: DateTime.now(),
    childDirected: false,
    designedForFamilies: false,
    gender: MobileAdGender.male, // or MobileAdGender.female, MobileAdGender.unknown
    testDevices: <String>[], // Android emulators are considered test devices
  );
  //Bildirim Paneli Satır Bloğu
  initializeNotification() async {
    PushNotificationsManager pushNotificationsManager =
    PushNotificationsManager();
    await pushNotificationsManager.init();
    await pushNotificationsManager.createChannel();
    pushNotificationsManager.notificationSubject.stream.listen((event) {
      //show popup..
      var type = event['type'];
      var message = event['value']['data'];
      message.forEach((key, value) {
        if (key == 'name') {
          showAlertMessage("$value", type);
        }
      });
    });
  }
  showAlertMessage(String message, String header) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text(header),
              content: Text(message),
              actions: <Widget>[
                FlatButton(
                  child: Text('Tamam'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ]);
        });
  }

  @override
  void initState() {
    //Bidirim PAneli
    initializeNotification();
    super.initState();
  }
  @override
  void dispose() {
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {

    return MultiBlocProvider(
        providers: [
          BlocProvider<UrunBloc>(create: (context) => UrunBloc()),
          BlocProvider<TakipBloc>(create: (context) => TakipBloc()),
          BlocProvider<FavoriBloc>(create: (context) => FavoriBloc()),
          BlocProvider<KategoriBloc>(create: (context) => KategoriBloc())
        ], child: Scaffold(body: BottomNavBar()));
  }

  _MyHomePageState();


}
