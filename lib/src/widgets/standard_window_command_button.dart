import 'package:flutter/material.dart';
import 'package:gtk_window/src/widgets/window_command_button.dart';
import 'package:gtk_window/src/window_decoration.dart';
import 'package:window_manager/window_manager.dart';

class StandardWindowCommandButton extends StatelessWidget {
  final WindowDecoration decoration;
  final bool isFocused;
  final bool isMaximized;

  const StandardWindowCommandButton(
      {Key? key,
      required this.decoration,
      required this.isFocused,
      required this.isMaximized})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (decoration) {
      case WindowDecoration.minimize:
        return WindowCommandButton(
          onPressed: windowManager.minimize,
          icon: Icons.minimize_rounded,
          isFocused: isFocused,
        );
      case WindowDecoration.maximize:
        return WindowCommandButton(
          onPressed: () async {
            isMaximized
                ? await windowManager.unmaximize()
                : await windowManager.maximize();
          },
          icon: Icons.crop_square_sharp,
          isFocused: isFocused,
        );
      case WindowDecoration.close:
        return WindowCommandButton(
          onPressed: windowManager.close,
          icon: Icons.close_rounded,
          isFocused: isFocused,
        );
      default:
        return const SizedBox();
    }
  }
}
