import 'package:albify/firebase_options.dart';
import 'package:albify/navigation/app_routes.dart';
import 'package:albify/screens/starting_page.dart';
import 'package:albify/screens/wrapper_builder.dart';
import 'package:albify/services/auth_service.dart';
import 'package:albify/themes/app_style.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider<AuthService>(
      create: (_) => AuthService(),
      child: WrapperBuilder(builder: (context) {
        return MaterialApp(
          title: 'Albify',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              primarySwatch: AppStyle.appColorBlack,
              scaffoldBackgroundColor: AppStyle.appColorBlack),
          initialRoute: StartingPage.ROUTE_ID,
          routes: AppRoutes.routes,
        );
      }),
    );
  }
}
