import "package:flutter/material.dart";
import "package:keyboard_dismisser/keyboard_dismisser.dart";
import "package:openai_demo/screen/home_screen.dart";
import "package:openai_demo/singleton/dio_singleton.dart";

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DioSingleton().addPrettyDioLoggerInterceptor();
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return KeyboardDismisser(
      child: MaterialApp(
        title: "OpenAI Image Generation Demo",
        theme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.light,
          colorSchemeSeed: Colors.blue,
        ),
        darkTheme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.dark,
          colorSchemeSeed: Colors.blue,
        ),
        home: const HomeScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
