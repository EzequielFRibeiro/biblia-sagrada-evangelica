import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'data/providers/providers.dart';
import 'ui/pages/reader/reader_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const BibliaSagradaApp());
}

class BibliaSagradaApp extends StatelessWidget {
  const BibliaSagradaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BibleProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => StudyProvider()),
        ChangeNotifierProvider(create: (_) => SermonProvider()),
      ],
      child: MaterialApp(
        title: 'Bíblia Sagrada Evangélica',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        home: const ReaderPage(),
        onGenerateRoute: AppRouter.generateRoute,
        locale: const Locale('pt', 'BR'),
        localizationsDelegates: const [
          DefaultMaterialLocalizations.delegate,
          DefaultWidgetsLocalizations.delegate,
        ],
      ),
    );
  }
}
