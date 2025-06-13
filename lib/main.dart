import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart'; // ✅ Tambahkan ini
import 'package:tb_kelompok1_b/routes/app_route.dart';
import 'package:tb_kelompok1_b/controller/news_controller.dart'; // ✅ Import controller

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    return ScreenUtilInit(
      designSize: const Size(360, 800),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return MultiProvider(
          providers: [ChangeNotifierProvider(create: (_) => NewsController())],
          child: MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'Frost News',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            ),
            routerConfig: AppRouter().goRouter,
          ),
        );
      },
    );
  }
}
