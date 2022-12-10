import 'package:flutter/material.dart';
import 'package:gtk_window/src/colors.dart';

class WindowCommandButton extends StatelessWidget {
  const WindowCommandButton({
    Key? key,
    required this.onPressed,
    required this.icon,
  }) : super(key: key);

  final Function onPressed;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return SizedBox.fromSize(
      size: const Size.square(24),
      child: Material(
        color: isDark
            ? GTKColors.darkWindowCommandButtonBackground
            : GTKColors.lightWindowCommandButtonBackground,
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
