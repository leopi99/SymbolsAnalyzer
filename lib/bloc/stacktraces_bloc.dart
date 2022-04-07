import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:process_run/shell.dart';
import 'package:rxdart/rxdart.dart';
import 'package:symbols_analyzer/models/stacktrace.dart';

class StackTraceBloc {
  List<Stacktrace> _stacktraceList = [];
  // final Shell _shell = Shell();
  final String _tempDirPath;
  late final _symbolDir;

  final BehaviorSubject<List<Stacktrace>> _stacktraceSubject =
      BehaviorSubject.seeded([]);

  Stream<List<Stacktrace>> get stacktraceStream => _stacktraceSubject.stream;

  bool get stacktraceAdded => _stacktraceList.isNotEmpty;

  StackTraceBloc(this._tempDirPath, BuildContext context) {
    Future.delayed(const Duration(milliseconds: 500), () {
      if (Platform.isWindows) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return ContentDialog(
              title: const Text("Select the symbols file"),
              actions: [
                Button(
                  child: const Text("Select"),
                  onPressed: () async {
                    final result = await FilePicker.platform.pickFiles(
                      dialogTitle: "Select the symbols file",
                      allowedExtensions: [".symbols"],
                      allowMultiple: false,
                    );
                    _symbolDir = result!.paths.first;
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          },
        );
      } else {
        showMacosAlertDialog(
          context: context,
          builder: (_) => MacosAlertDialog(
            appIcon: const FlutterLogo(
              size: 56,
            ),
            title: Text(
              'Select the symbols file',
              style: MacosTheme.of(context).typography.headline,
            ),
            message: Text(
              'To use the app, please select the symbol file to deObfuscate',
              textAlign: TextAlign.center,
              style: MacosTheme.of(context).typography.headline,
            ),
            primaryButton: PushButton(
              buttonSize: ButtonSize.large,
              child: const Text('Select'),
              onPressed: () async {
                final result = await FilePicker.platform.pickFiles(
                  dialogTitle: "Select the symbols file",
                  allowedExtensions: [".symbols"],
                  allowMultiple: false,
                );
                _symbolDir = result!.paths.first;
                Navigator.pop(context);
              },
            ),
          ),
        );
      }
    });
  }

  void addStacktrace(Stacktrace stacktrace) {
    _stacktraceList.add(stacktrace);
    _stacktraceSubject.add(_stacktraceList);
  }

  Future<void> deObfuscate() async {
    await _deObfuscateRecursion(0);
  }

  Future<void> _deObfuscateRecursion(int index) async {
    if (_stacktraceList[index].obfuscated != null) {
      final file = File("$_tempDirPath/obfuscated$index.txt");
      file.writeAsString(_stacktraceList[index].obfuscated!);
      final process = await Process.run(
          "flutter symbolize -i ${file.path} -d $_symbolDir", []);
      _stacktraceList[index] =
          _stacktraceList[index].copyWith(deObfuscated: process.outText);
      await file.delete();
    }
    index++;
    if (index < _stacktraceList.length) {
      await _deObfuscateRecursion(index);
    } else {
      _stacktraceSubject.add(_stacktraceList);
    }
  }

  void updateStacktrace(Stacktrace trace, int index) {
    _stacktraceList[index] = trace;
  }

  void dispose() {
    _stacktraceSubject.close();
  }
}
