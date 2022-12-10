import 'package:flutter/material.dart';
import 'package:gtk_window/src/colors.dart';
import 'package:gtk_window/src/widgets/window_command_button.dart';
import 'package:window_manager/window_manager.dart';

class GTKHeaderBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget title;
  const GTKHeaderBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    WindowManager wm = WindowManager.instance;
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: isDark ? GTKColors.darkBackground : GTKColors.lightBackground,
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
          onPanStart: (_) => onPanStart(wm),
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
                Center(child: title),
                Positioned(
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      children: [
                        WindowCommandButton(
                          onPressed: wm.minimize,
                          icon: Icons.minimize_rounded,
                        ),
                        const SizedBox(width: 14),
                        WindowCommandButton(
                          onPressed: wm.close,
                          icon: Icons.close_rounded,
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

  void onPanStart(WindowManager wm) async => await wm.startDragging();

  @override
  Size get preferredSize => const Size.fromHeight(44);
}
