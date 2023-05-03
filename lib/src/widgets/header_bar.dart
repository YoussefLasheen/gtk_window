import 'package:flutter/material.dart';
import 'package:gtk_window/src/colors.dart';
import 'package:gtk_window/src/widgets/standard_window_command_button.dart';
import 'package:gtk_window/src/window_decoration.dart';
import 'package:gtk_window/src/window_decoration_layout.dart';
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
  final WindowDecorationLayout? decorationLayout;
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
    this.decorationLayout = const WindowDecorationLayout([], [
      WindowDecoration.minimize,
      WindowDecoration.maximize,
      WindowDecoration.close
    ]),
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
    windowManager.setTitleBarStyle(TitleBarStyle.hidden);
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
                        leading: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            if (widget.decorationLayout != null)
                              ..._generateWindowDecorations(
                                  widget.decorationLayout!.leftItems),
                            if (widget.decorationLayout != null &&
                                widget.decorationLayout!.leftItems.isNotEmpty)
                              const SizedBox(width: 11),
                            if (ModalRoute.of(context)!.canPop)
                              const BackButton(),
                            if (ModalRoute.of(context)!.canPop)
                              const SizedBox(width: 11),
                            ...?widget.leading,
                          ],
                        ),
                        middle: widget.middle,
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            ...?widget.trailing,
                            if (widget.trailing?.isNotEmpty ?? false)
                              const SizedBox(width: 11),
                            if (widget.decorationLayout != null)
                              ..._generateWindowDecorations(
                                  widget.decorationLayout!.rightItems)
                          ],
                        )),
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

  List<Widget> _generateWindowDecorations(List<WindowDecoration> items) {
    if (items.isNotEmpty) {
      return List.generate(
          items.length * 2 - 1,
          (index) => (index % 2 == 0)
              ? StandardWindowCommandButton(
                  decoration: items[index ~/ 2],
                  isFocused: isFocused,
                  isMaximized: isMaximized)
              : const SizedBox(width: 13));
    } else {
      return [];
    }
  }

  void onPanStart() async => await windowManager.startDragging();
  void onDoubleTap() async => isMaximized
      ? await windowManager.unmaximize()
      : await windowManager.maximize();
}
