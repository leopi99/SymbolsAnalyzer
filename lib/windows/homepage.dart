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
    return Container(
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
                  maxLines: null,
                  minLines: null,
                  expands: true,
                  placeholder: "Insert here your stacktrace...",
                  controller: controller,
                  onSubmitted: (value) {
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
                  maxLines: null,
                  minLines: null,
                  expands: true,
                  placeholder: "Here you will find the deobfuscated stacktrace",
                  readOnly: true,
                  controller: controller,
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
