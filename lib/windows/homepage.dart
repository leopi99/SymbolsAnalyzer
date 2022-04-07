import 'package:fluent_ui/fluent_ui.dart';
import 'package:symbols_analyzer/bloc/stacktraces_bloc.dart';
import 'package:symbols_analyzer/common_widgets/stacktraces_widget.dart';

class WindowsHomepage extends StatelessWidget {
  final StackTraceBloc bloc;

  const WindowsHomepage({
    Key? key,
    required this.bloc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: Axis.vertical,
      children: [
        Flexible(
          flex: 1,
          child: Row(
            children: [
              Button(
                child: const Text("Run deObfuscation"),
                onPressed: () async {
                  await bloc.deObfuscate();
                },
              ),
            ],
          ),
        ),
        Flexible(
          flex: 9,
          child: Flex(
            direction: Axis.horizontal,
            children: [
              Flexible(
                flex: 5,
                child: StackTracesWidget(
                  bloc: bloc,
                  textFieldWidget: (trace, index) {
                    final controller =
                        TextEditingController(text: trace?.obfuscated);
                    return TextBox(
                      expands: true,
                      minLines: null,
                      maxLines: null,
                      scrollPhysics: const BouncingScrollPhysics(),
                      placeholder: "Insert here your stacktrace...",
                      controller: controller,
                      onChanged: (value) {
                        bloc.updateStacktrace(
                            trace!.copyWith(obfuscated: value), index);
                      },
                    );
                  },
                ),
              ),
              Flexible(
                flex: 5,
                child: StackTracesWidget(
                  bloc: bloc,
                  showAdd: false,
                  textFieldWidget: (trace, _) {
                    final controller =
                        TextEditingController(text: trace?.deObfuscated);
                    return TextBox(
                      expands: true,
                      minLines: null,
                      maxLines: null,
                      scrollPhysics: const BouncingScrollPhysics(),
                      readOnly: true,
                      placeholder:
                          "Here you will find the deobfuscated stacktrace",
                      controller: controller,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
