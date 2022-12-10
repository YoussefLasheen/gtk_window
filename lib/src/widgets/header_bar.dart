import 'package:flutter/material.dart';
import 'package:gtk_window/src/colors.dart';
import 'package:gtk_window/src/widgets/window_command_button.dart';
import 'package:window_manager/window_manager.dart';

class GTKHeaderBar extends StatefulWidget implements PreferredSizeWidget {
  final Widget title;
  const GTKHeaderBar({super.key, required this.title});

  @override
  Size get preferredSize => const Size.fromHeight(44);

  @override
  State<GTKHeaderBar> createState() => _GTKHeaderBarState();
}

class _GTKHeaderBarState extends State<GTKHeaderBar> with WindowListener {
  bool isFocused = false;
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
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
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
            color: isDark ? GTKColors.darkBorder : GTKColors.lightBorder,
            width: 1,
          ),
        ),
      ),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onDoubleTap: () async {
            isMaximized
                ? await windowManager.unmaximize()
                : await windowManager.maximize();
          },
          onPanStart: (_) => onPanStart(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Stack(
              fit: StackFit.expand,
              alignment: Alignment.center,
              children: [
                if (ModalRoute.of(context)!.canPop)
                  Positioned(
                    left: 0,
                    child: InkWell(
                      hoverColor: Colors.white12,
                      borderRadius: BorderRadius.circular(7),
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.arrow_back_rounded,
                          size: 17,
                        ),
                      ),
                      onTap: () => Navigator.pop(context),
                    ),
                  ),
                Center(child: widget.title),
                Positioned(
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      children: [
                        WindowCommandButton(
                          onPressed: windowManager.minimize,
                          icon: Icons.minimize_rounded,
                          isFocused: isFocused,
                        ),
                        const SizedBox(width: 14),
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
                        WindowCommandButton(
                          onPressed: windowManager.close,
                          icon: Icons.close_rounded,
                          isFocused: isFocused,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onPanStart() async => await windowManager.startDragging();
  void onDoubleTap() async => isMaximized
      ? await windowManager.unmaximize()
      : await windowManager.maximize();
}
