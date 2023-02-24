import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:instaclone/providers/user_provider.dart';
import 'package:instaclone/screens/login_screen.dart';
import 'package:instaclone/screens/sign_up_screen.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:instaclone/responsive/mobile_screen_layout.dart';
import 'package:instaclone/responsive/responsive_layout_screen.dart';
import 'package:instaclone/responsive/web_screen_layout.dart';
import './utils/colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyCAKpV4G9qOwdZYVL60JPbtjoVbiu4b0fk",
        authDomain: "instagramclone-96d7d.firebaseapp.com",
        projectId: "instagramclone-96d7d",
        storageBucket: "instagramclone-96d7d.appspot.com",
        messagingSenderId: "725025459044",
        appId: "1:725025459044:web:90fbf9fbbe9f59c2e64871",
      ),
    );
  } else {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Instagram Clone',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: mobileBackgroundColor,
        ),
        // home: ResponsiveLayout(
        //   mobileScreenLayout: MobileScreenLayout(),
        //   webScreenLayout: WebScreenLayout(),
        // ),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: ((context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                return const ResponsiveLayout(
                  mobileScreenLayout: MobileScreenLayout(),
                  webScreenLayout: WebScreenLayout(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('${snapshot.error}'),
                );
              }
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                  child: CircularProgressIndicator(
                color: primaryColor,
              ));
            }
            return const LoginScreen();
          }),
        ),
      ),
    );
  }
}
