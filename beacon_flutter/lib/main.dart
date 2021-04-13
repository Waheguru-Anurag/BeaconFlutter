import 'package:beacon_flutter/services/navigation_service.dart';
import 'package:beacon_flutter/views/router.dart';
import 'package:beacon_flutter/views/startup_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:beacon_flutter/locator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setUpLocator();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) => runApp(
            GetMaterialApp(home: MyApp()),
          ));

  final FirebaseOptions firebaseOptions = const FirebaseOptions(
    appId: '1:680712003699:android:0e71fca0f18c99ea020a06',
    messagingSenderId: '680712003699',
    apiKey: 'AIzaSyAiht3UzToZ4fA6mpCxZ9OoGtYkhcNTxEc',
    projectId: 'beaconflutter-ce00c',
  );
  await Firebase.initializeApp(options: firebaseOptions);
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor:
          Color(0x2980B9).withOpacity(1), //or set color with: Color(0xFF0000FF)
    ));
    ScreenUtil.init(context, width: 360, height: 746, allowFontScaling: true);
    return MaterialApp(
      title: 'BeaconFlutter',
      navigatorKey: locator<NavigationService>().navigatorKey,
      onGenerateRoute: CustomRouter.generateRoute,
      theme: ThemeData(backgroundColor: Colors.white),
      home: StartUpView(),
    );
  }
}
