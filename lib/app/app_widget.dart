import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/theme/app_theme.dart';
import '../features/auth/presentation/pages/login_page.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Controllers entrarão nos próximos commits
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Controle de Abastecimento',
        theme: AppTheme.temaClaro,
        home: const LoginPage(),
      ),
    );
  }
}
