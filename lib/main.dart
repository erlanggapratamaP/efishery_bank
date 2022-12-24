import 'package:efishery_bank/view/ui/add_fish_view.dart';
import 'package:efishery_bank/view/ui/dashboard_view.dart';
import 'package:efishery_bank/view/widgets/filter_dialog_view.dart';
import 'package:efishery_bank/viewmodel/add_fish_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'viewmodel/fish_viewmodel.dart';

void main() {
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

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'eFishery-Bank',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const DashboardView(),
    );
  }
}
