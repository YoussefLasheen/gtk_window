import 'package:flutter/material.dart';
import 'package:gtk_window/src/colors.dart';
import 'package:gtk_window/src/widgets/window_command_button.dart';
import 'package:window_manager/window_manager.dart';

class GTKHeaderBar extends StatefulWidget implements PreferredSizeWidget {
  final List<Widget>? leading;
  final Widget? middle;
  final List<Widget>? trailing;
  final PreferredSizeWidget? bottom;
  final double height;
  final double middleSpacing;
  final EdgeInsetsGeometry padding;
  final bool showLeading;
  final bool showTrailing;
  final bool showMaximizeButton;
  final bool showMinimizeButton;
  final bool showCloseButton;
  final bool showWindowControlsButtons;
  final Function? onWindowResize;
  const GTKHeaderBar({
    super.key,
    this.leading,
    this.middle,
    this.trailing,
    this.bottom,
    this.height = 44,
    this.middleSpacing = 10,
    this.padding = const EdgeInsets.symmetric(horizontal: 10),
    this.showLeading = true,
    this.showTrailing = true,
    this.showMaximizeButton = true,
    this.showMinimizeButton = true,
    this.showCloseButton = true,
    this.showWindowControlsButtons = true,
    this.onWindowResize,
  });

  @override
  Size get preferredSize =>
      Size.fromHeight(height + (bottom?.preferredSize.height ?? 0));

  @override
  State<GTKHeaderBar> createState() => _GTKHeaderBarState();
}

class _GTKHeaderBarState extends State<GTKHeaderBar> with WindowListener {
  bool isFocused = true;
  bool isMaximized = false;
  @override
  void initState() {
    windowManager.addListener(this);
    super.initState();
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }

  @override
  void onWindowFocus() {
    setState(() {
      isFocused = true;
    });
  }

  @override
  void onWindowBlur() {
    setState(() {
      isFocused = false;
    });
  }

  @override
  void onWindowMaximize() {
    setState(() {
      isMaximized = true;
    });
  }

  @override
  void onWindowUnmaximize() {
    setState(() {
      isMaximized = false;
    });
  }

  @override
  Future<void> onWindowResize() async {
    if (widget.onWindowResize != null) {
      widget.onWindowResize!(await windowManager.getSize());
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    Widget? leading;
    leading = Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (ModalRoute.of(context)!.canPop) const BackButton(),
        if (widget.leading != null)
          for (var item in widget.leading!) item,
      ],
    );

    Widget? trailing;
    if (!widget.showWindowControlsButtons) {
      trailing = Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (widget.leading != null)
            for (var item in widget.trailing!) item,
        ],
      );
    } else {
      trailing = Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (widget.leading != null)
            for (var item in widget.trailing!) item,
          if (widget.showMinimizeButton)
            WindowCommandButton(
              onPressed: windowManager.minimize,
              icon: Icons.minimize_rounded,
              isFocused: isFocused,
            ),
          const SizedBox(width: 14),
          if (widget.showMaximizeButton)
            WindowCommandButton(
              onPressed: () async {
                isMaximized
                    ? await windowManager.unmaximize()
                    : await windowManager.maximize();
              },
              icon: Icons.crop_square_sharp,
              isFocused: isFocused,
            ),
          const SizedBox(width: 14),
          if (widget.showCloseButton)
            WindowCommandButton(
              onPressed: windowManager.close,
              icon: Icons.close_rounded,
              isFocused: isFocused,
            ),
        ],
      );
    }

    return Material(
      color: Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: widget.height),
              child: Container(
                decoration: BoxDecoration(
                  color: isFocused
                      ? isDark
                          ? GTKColors.darkFocusedBackground
                          : GTKColors.lightFocusedBackground
                      : isDark
                          ? GTKColors.darkUnfocusedBackground
                          : GTKColors.lightUnfocusedBackground,
                  border: Border(
                    bottom: BorderSide(
                      color:
                          isDark ? GTKColors.darkBorder : GTKColors.lightBorder,
                      width: 1,
                    ),
                  ),
                ),
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onDoubleTap: () async {
                    isMaximized
                        ? await windowManager.unmaximize()
                        : await windowManager.maximize();
                  },
                  onPanStart: (_) => onPanStart(),
                  child: Padding(
                    padding: widget.padding,
                    child: NavigationToolbar(
                        middleSpacing: widget.middleSpacing,
                        leading: leading,
                        middle: widget.middle,
                        trailing: trailing),
                  ),
                ),
              ),
            ),
          ),
          widget.bottom ?? const SizedBox.shrink(),
        ],
      ),
    );
  }

  void onPanStart() async => await windowManager.startDragging();
  void onDoubleTap() async => isMaximized
      ? await windowManager.unmaximize()
      : await windowManager.maximize();
}
