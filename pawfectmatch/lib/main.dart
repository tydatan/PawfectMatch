import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pawfectmatch/blocs/bloc.dart';
import 'package:pawfectmatch/screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'models/models.dart';
import 'repositories/database_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return 
    MultiRepositoryProvider(
      providers: [
        
        RepositoryProvider(
          create: (context) => DatabaseRepository(),
        ),
        
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (context) => SwipeBloc( 
                databaseRepository: context.read<DatabaseRepository>(),
                  )
              //BlocProvider.of<AuthBloc>(context).state.user!.uid),
              ),
        ], child:

    MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff011F3F)),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
      )
    )
    );
  }
}
