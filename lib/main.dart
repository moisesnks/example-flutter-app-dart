import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'views/login/login_screen.dart';
import 'views/home/home_screen.dart';
import 'views/register/register_screen.dart';
import 'viewmodels/login_viewmodel.dart';
import 'viewmodels/register_viewmodel.dart';
import 'viewmodels/profile_viewmodel.dart';
import 'services/auth_service.dart';
import 'services/firestore_service.dart';
import 'services/storage_service.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AuthService authService = AuthService();
    final FirestoreService firestoreService = FirestoreService();
    final StorageService storageService = StorageService();

    return MultiProvider(
      providers: [
        Provider<AuthService>(create: (_) => authService),
        Provider<FirestoreService>(create: (_) => firestoreService),
        ChangeNotifierProvider(create: (_) => LoginViewModel(authService)),
        ChangeNotifierProvider(
            create: (_) =>
                RegistrationViewModel(authService, firestoreService)),
        ChangeNotifierProvider(
            create: (_) => ProfileViewModel(
                firestoreService, authService, storageService)),
      ],
      child: MaterialApp(
        title: 'Mi aplicación',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          appBarTheme: AppBarTheme(color: Colors.blue[800]),
          buttonTheme: ButtonThemeData(buttonColor: Colors.blue[700]),
          textTheme: TextTheme(
            headlineMedium: TextStyle(fontSize: 20.0, color: Colors.black),
            bodyMedium: TextStyle(fontSize: 16.0, color: Colors.black),
          ),
        ),
        initialRoute: '/login',
        routes: {
          '/login': (context) => LoginScreen(),
          '/home': (context) => HomeScreen(),
          '/register': (context) => RegisterScreen(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
