import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/theme/app_theme.dart';

import '../features/auth/data/repositories/auth_repository.dart';
import '../features/auth/presentation/controllers/auth_controller.dart';
import '../features/auth/presentation/pages/login_page.dart';

import '../features/home/presentation/pages/home_page.dart';

import '../features/veiculo/data/repositories/veiculo_repository.dart';
import '../features/veiculo/presentation/controllers/veiculo_controller.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthController(AuthRepository())),
        ChangeNotifierProxyProvider<AuthController, VeiculoController>(
          create: (context) => VeiculoController(
            VeiculoRepository(),
            context.read<AuthController>(),
          ),
          update: (context, auth, veiculoControllerAnterior) {
            return VeiculoController(VeiculoRepository(), auth);
          },
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.temaClaro,
        home: const _RoteadorAuth(),
      ),
    );
  }
}

class _RoteadorAuth extends StatelessWidget {
  const _RoteadorAuth({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthController>();

    if (auth.usuario != null) {
      return const HomePage();
    }

    return const LoginPage();
  }
}
