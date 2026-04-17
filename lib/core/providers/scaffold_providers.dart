import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Global key for the AppShell's Scaffold so any screen can open the drawer.
final shellScaffoldKeyProvider = Provider<GlobalKey<ScaffoldState>>(
  (_) => GlobalKey<ScaffoldState>(),
);
