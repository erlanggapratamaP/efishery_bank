import 'package:efishery_bank/helpers/check_connectivity.dart';
import 'package:efishery_bank/view/ui/add_fish_view.dart';
import 'package:efishery_bank/view/ui/dashboard_view.dart';
import 'package:efishery_bank/view/widgets/filter_dialog_view.dart';
import 'package:efishery_bank/viewmodel/add_fish_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'viewmodel/fish_viewmodel.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => FishViewModel(),
          child: const MaterialApp(home: DashboardView()),
        ),
        ChangeNotifierProvider(
          create: (context) => FishViewModel(),
          child: const MaterialApp(
              home: FilterDialogView(
            filterOnTap: null,
          )),
        ),
        ChangeNotifierProvider(
          create: (context) => AddFishViewModel(),
          child: const MaterialApp(home: AddFishView()),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  //check connection
  bool isLoading = true;
  Future<void> _checkConnection(context) async {
    await ConnectionCheck(context).initConnectivity();
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    () async {
      await _checkConnection(context);
    }();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'eFishery-Bank',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: isLoading
          ? const Scaffold(
              body: Center(
                  child: CircularProgressIndicator(
                color: Colors.blue,
              )),
            )
          : const DashboardView(),
    );
  }
}
