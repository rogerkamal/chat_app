import 'package:chat_app/data/remote/firebase_repository.dart';
import 'package:chat_app/domain/utils/firebase_options.dart';
import 'package:chat_app/domain/utils/app_routes.dart';
import 'package:chat_app/ui/login/cubit/login_cubit.dart';
import 'package:chat_app/ui/signup/cubit/signup_cubit.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    RepositoryProvider(
      create: (context) => FirebaseRepository(),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create:
                (context) => SignupCubit(
                  firebaseRepository: RepositoryProvider.of<FirebaseRepository>(
                    context,
                  ),
                ),
          ),
          BlocProvider(
            create:
                (context) => LoginCubit(
                  firebaseRepository: RepositoryProvider.of<FirebaseRepository>(
                    context,
                  ),
                ),
          ),
        ],
        child: MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
      ),
      routes: AppRoutes.getRoutes(),
      initialRoute: AppRoutes.splash,
      // home: SplashPage(),
    );
  }
}
