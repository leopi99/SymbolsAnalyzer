import 'dart:io';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:path_provider/path_provider.dart';
import 'package:symbols_analyzer/bloc/stacktraces_bloc.dart';
import 'package:symbols_analyzer/macos/homepage.dart';
import 'package:symbols_analyzer/windows/homepage.dart';

const _kAppName = "Symbols Analyzer";

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  StackTraceBloc? bloc;

  @override
  Widget build(BuildContext context) {
    return Platform.isMacOS ? _macOsApp() : _windowsApp();
  }

  Widget _windowsApp() {
    return FluentApp(
      title: _kAppName,
      locale: const Locale('en'),
      home: FutureBuilder<Directory>(
        future: getTemporaryDirectory(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          bloc ??= StackTraceBloc(snapshot.data!.path, context);
          return WindowsHomepage(bloc: bloc!);
        },
      ),
    );
  }

  Widget _macOsApp() {
    return MacosApp(
      title: _kAppName,
      locale: const Locale('en'),
      home: FutureBuilder<Directory>(
        future: getTemporaryDirectory(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          bloc ??= StackTraceBloc(snapshot.data!.path, context);
          return MacOsHomepage(bloc: bloc!);
        },
      ),
    );
  }
}
