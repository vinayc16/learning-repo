import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:learning_statemanejment/study_buddy_ai_power/screen/study_buddy_screen.dart';
import 'package:provider/provider.dart';
import 'hive/basic_hive.dart';
import 'hive/to-do_hive.dart';
import 'providers/product_provider.dart';
import 'screens/products/product_list_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('myBox');
  await Hive.openBox('todoBox');
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Product Store',
      theme: ThemeData(
        primaryColor: const Color(0xFFEB1555),
        fontFamily: 'Roboto',
      ),
      home: const StudyBuddyApp(),
    );
  }
}

///Pros
///1. Separation of concerns – Every file has its own responsibility.
///2. Provider state management – Reactive and efficient UI updates.
///3. Clean Architecture – Models, Services, Providers, and UI layers.
///4. Dio HTTP client – Proper error handling with interceptors.
///5. Scalable – Easy to add new features and maintain.

///Pros
///1. Separation of concerns – Every file has its own responsibility.
///2. Reactive programming – Obx automatically updates the UI.
///3. Navigation – Get.toName() makes navigation easier.
///4. Dependency injection – Automatic memory management.
///5. Scalable – Adding new features is easy, code remains simple, and the architecture stays powerful.