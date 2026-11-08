import 'package:flutter/material.dart';

class NexoraColors {
  static const accent = Color(0xFF5551E0);
  static const background = Color(0xFF111113);
  static const field = Color(0xFF18181B);
  static const border = Color(0xFF2A2A2F);
  static const textMuted = Color(0xFF8B8B93);
  static const sidebar = Color(0xFF0D0D0F);
  static const card = Color(0xFF17171A);
  static const gold = Color(0xFFE0A84A);
}

ThemeData buildNexoraTheme() {
  final base = ThemeData.dark(useMaterial3: true);
  return base.copyWith(
    scaffoldBackgroundColor: NexoraColors.background,
    colorScheme: base.colorScheme.copyWith(
      primary: NexoraColors.accent,
      surface: NexoraColors.background,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: NexoraColors.field,
      hintStyle: const TextStyle(color: NexoraColors.textMuted, fontSize: 14),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      border: _border(NexoraColors.border),
      enabledBorder: _border(NexoraColors.border),
      focusedBorder: _border(NexoraColors.accent),
      errorBorder: _border(Colors.redAccent),
      focusedErrorBorder: _border(Colors.redAccent),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: NexoraColors.accent,
        foregroundColor: Colors.white,
        minimumSize: const Size.fromHeight(52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
      ),
    ),
  );
}

OutlineInputBorder _border(Color color) => OutlineInputBorder(
  borderRadius: BorderRadius.circular(8),
  borderSide: BorderSide(color: color),
);
