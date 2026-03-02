import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'database_helper.dart';

class StorageService {
  static Future<void> saveUsuario(Map<String, dynamic> usuario) async {
    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      final list = prefs.getStringList('usuarios') ?? [];
      list.add(jsonEncode(usuario));
      await prefs.setStringList('usuarios', list);
    } else {
      await DatabaseHelper.instance.insertUsuario(usuario);
    }
  }

  static Future<List<Map<String, dynamic>>> getUsuarios() async {
    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      final list = prefs.getStringList('usuarios') ?? [];
      return list
          .map((e) => jsonDecode(e))
          .cast<Map<String, dynamic>>()
          .toList();
    } else {
      return await DatabaseHelper.instance.getUsuarios();
    }
  }
}