import 'dart:io';

import 'package:fluent_ui/fluent_ui.dart' show TextBox, Button;
import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart'
    show MacosTextField, PushButton, ButtonSize;
import 'package:symbols_analyzer/common_widgets/stacktraces_widget.dart';
import 'package:symbols_analyzer/models/stacktrace.dart';
import 'package:symbols_analyzer/presentation/homepage/bloc/stacktraces_bloc.dart';

class Homepage extends StatelessWidget {
  final StackTraceBloc bloc;

  const Homepage({
    Key? key,
    required this.bloc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Flex(
        direction: Axis.vertical,
        children: [
          Flexible(
            flex: 3,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Platform.isWindows
                      ? _buildWindowsDeObfuscateButton()
                      : _buildMacOsDeObfuscateButton(),
                ),
              ],
            ),
          ),
          Flexible(
            flex: 1405,
            child: StackTracesWidget(
              bloc: bloc,
              textFieldWidget: (trace, index) {
                final controller =
                    TextEditingController(text: trace?.obfuscated);
                final deController =
                    TextEditingController(text: trace?.deObfuscated);
                return Flex(
                  direction: Axis.horizontal,
                  children: [
                    Flexible(
                      flex: 5,
                      child: Platform.isWindows
                          ? _buildWindowsTextField(controller, trace, index)
                          : _buildMacOsTextField(controller, trace, index),
                    ),
                    const SizedBox(width: 32),
                    Flexible(
                      flex: 5,
                      child: Platform.isWindows
                          ? _buildWindowsTextField(
                              deController, trace, index, true)
                          : _buildMacOsTextField(
                              deController, trace, index, true),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMacOsTextField(
      TextEditingController controller, Stacktrace? trace, int index,
      [bool readOnly = false]) {
    return MacosTextField(
      expands: true,
      minLines: null,
      maxLines: null,
      readOnly: readOnly,
      scrollPhysics: const BouncingScrollPhysics(),
      placeholder: "Insert here your stacktrace...",
      controller: controller,
      onChanged: (value) {
        bloc.updateStacktrace(trace!.copyWith(obfuscated: value), index);
      },
    );
  }

  Widget _buildWindowsTextField(
      TextEditingController controller, Stacktrace? trace, int index,
      [bool readOnly = false]) {
    return TextBox(
      expands: true,
      minLines: null,
      maxLines: null,
      readOnly: readOnly,
      placeholder: "Insert here your stacktrace...",
      controller: controller,
      onChanged: (value) {
        bloc.updateStacktrace(trace!.copyWith(obfuscated: value), index);
      },
    );
  }

  Widget _buildWindowsDeObfuscateButton() {
    return Button(
      child: const Text("Run deObfuscation"),
      onPressed: () async {
        await bloc.deObfuscate();
      },
    );
  }

  Widget _buildMacOsDeObfuscateButton() {
    return PushButton(
      child: const Text("Run deObfuscation"),
      buttonSize: ButtonSize.large,
      onPressed: () async {
        await bloc.deObfuscate();
      },
    );
  }
}
