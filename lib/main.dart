
import 'package:flutter/material.dart' hide ButtonBar;
import 'package:prisma_orm/common/widgets/button_bar.dart';
import 'package:prisma_orm/constants/global_variable.dart';
import 'package:prisma_orm/features/admin/screens/admin_screen.dart' show AdminScreen;
import 'package:prisma_orm/features/auth/screens/auth_screens.dart';
import 'package:prisma_orm/features/auth/services/auth_service.dart';
import 'package:prisma_orm/providers/user_provider.dart';
import 'package:prisma_orm/router.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => UserProvider())],
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
  final AuthService authService = AuthService();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      authService.getUserData(context);
    });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true, //y
        colorScheme:
            ColorScheme.fromSeed(
              seedColor: GlobalVariables.secondaryColor,
            ).copyWith(
              primary: GlobalVariables.secondaryColor,
              secondary: GlobalVariables.secondaryColor,
            ),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: GlobalVariables.secondaryColor, // orange
            foregroundColor: Colors.white, // text/icon color
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: GlobalVariables.secondaryColor,
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: GlobalVariables.secondaryColor,
          ),
        ),
      ),

      onGenerateRoute: (settings) => generateRoute(settings),
      home: Provider.of<UserProvider>(context).user.token.isNotEmpty
          ? Provider.of<UserProvider>(context).user.type == 'user'
                ? const ButtomBar()
                : AdminScreen()
          : const AuthScreen(),
    );
  }
}
