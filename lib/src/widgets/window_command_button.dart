import 'package:flutter/material.dart';
import 'package:gtk_window/src/colors.dart';

class WindowCommandButton extends StatelessWidget {
  final bool isFocused;
  const WindowCommandButton({
    Key? key,
    required this.onPressed,
    required this.icon,
    required this.isFocused,
  }) : super(key: key);

  final Function onPressed;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return SizedBox.fromSize(
      size: const Size.square(24),
      child: Material(
        color: isFocused
            ? isDark
                ? GTKColors.darkFocusedWindowCommandButtonBackground
                : GTKColors.lightFocusedWindowCommandButtonBackground
            : isDark
                ? GTKColors.darkUnfocusedWindowCommandButtonBackground
                : GTKColors.lightUnfocusedWindowCommandButtonBackground,
        shape: const CircleBorder(),
        child: IconButton(
          color: isDark
              ? GTKColors.darkWindowCommandButtonIcon
              : GTKColors.lightWindowCommandButtonIcon,
          icon: Icon(icon),
          iconSize: 14,
          padding: EdgeInsets.zero,
          splashRadius: 12,
          onPressed: () => onPressed(),
        ),
      ),
    );
  }
}
