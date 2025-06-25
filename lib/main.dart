import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:tb_kelompok1_b/controller/author_news_controller.dart';
import 'package:tb_kelompok1_b/controller/bookmark_controller.dart';
import 'package:tb_kelompok1_b/routes/app_route.dart';
import 'package:tb_kelompok1_b/controller/news_controller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:tb_kelompok1_b/controller/auth_author_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Firebase dengan opsi untuk platform saat ini
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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
          providers: [
            ChangeNotifierProvider(create: (_) => NewsController()),
            ChangeNotifierProvider(create: (_) => AuthAuthorController()),
            ChangeNotifierProxyProvider<
              AuthAuthorController,
              AuthorNewsController
            >(
              create: (_) => AuthorNewsController(token: ''),
              update:
                  (_, auth, previous) =>
                      AuthorNewsController(token: auth.token ?? ''),
            ),
            ChangeNotifierProvider(create: (_) => BookmarkController()),
          ],
          child: MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'News Frost',
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
