import 'dart:io';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:symbols_analyzer/models/stacktrace.dart';
import 'package:symbols_analyzer/presentation/homepage/bloc/stacktraces_bloc.dart';

class StackTracesWidget extends StatelessWidget {
  final StackTraceBloc bloc;

  final Function(Stacktrace?, int) textFieldWidget;

  final bool showAdd;

  const StackTracesWidget({
    Key? key,
    required this.bloc,
    required this.textFieldWidget,
    this.showAdd = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Stacktrace>>(
      stream: bloc.stacktraceStream,
      initialData: const [],
      builder: (context, snapshot) {
        return ListView.builder(
          itemCount: (bloc.stacktraceAdded ? snapshot.data!.length : 1) +
              (showAdd ? 1 : 0),
          itemBuilder: (context, index) {
            Stacktrace? trace;
            if (bloc.stacktraceAdded && index < snapshot.data!.length) {
              trace = snapshot.data![index];
            }
            if (index >= snapshot.data!.length && index > 0) {
              return Center(
                child: Platform.isWindows
                    ? Button(
                        child: const Text("Add"),
                        onPressed: () {
                          bloc.addStacktrace(Stacktrace(index: index));
                        },
                      )
                    : PushButton(
                        child: const Text("Add"),
                        buttonSize: ButtonSize.large,
                        onPressed: () {
                          bloc.addStacktrace(Stacktrace(index: index));
                        },
                      ),
              );
            }
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
              child: textFieldWidget(trace, index),
            );
          },
        );
      },
    );
  }
}
