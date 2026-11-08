import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'theme/app_theme.dart';

// Se pasan en compilación: --dart-define=SUPABASE_URL=... --dart-define=SUPABASE_ANON_KEY=...
const _supabaseUrl = String.fromEnvironment('SUPABASE_URL');
const _supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');
const _supabaseConfigurado = _supabaseUrl != '' && _supabaseAnonKey != '';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (_supabaseConfigurado) {
    await Supabase.initialize(
      url: _supabaseUrl,
      publishableKey: _supabaseAnonKey,
    );
  }
  runApp(const NexoraApp());
}

class NexoraApp extends StatelessWidget {
  const NexoraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nexora',
      debugShowCheckedModeBanner: false,
      theme: buildNexoraTheme(),
      home: _supabaseConfigurado
          ? const _PuertaDeAcceso()
          : const LoginScreen(),
    );
  }
}

/// Muestra el login o el inicio según haya sesión de Supabase.
class _PuertaDeAcceso extends StatelessWidget {
  const _PuertaDeAcceso();

  @override
  Widget build(BuildContext context) {
    final auth = Supabase.instance.client.auth;
    return StreamBuilder<AuthState>(
      stream: auth.onAuthStateChange,
      builder: (context, snapshot) {
        final sesion = snapshot.data?.session ?? auth.currentSession;
        if (sesion == null) return const LoginScreen();

        final meta = sesion.user.userMetadata;
        final nombre = (meta?['nombre'] as String?)?.trim();
        final correo = sesion.user.email ?? '';
        return HomeScreen(
          nombreUsuario: (nombre != null && nombre.isNotEmpty)
              ? nombre.split(' ').first
              : correo.split('@').first,
          onCerrarSesion: auth.signOut,
        );
      },
    );
  }
}
