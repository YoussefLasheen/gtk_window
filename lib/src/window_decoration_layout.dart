import 'package:gtk/gtk.dart';
import 'package:gtk_window/src/window_decoration.dart';

class WindowDecorationLayout {
  final List<WindowDecoration> leftItems;
  final List<WindowDecoration> rightItems;

  const WindowDecorationLayout(this.leftItems, this.rightItems);

  static WindowDecorationLayout fromGTKTheme() {
    final layoutString =
        GtkSettings().getProperty("gtk-decoration-layout") as String;
    final splitSideStrings = layoutString.split(":");
    final leftItemStrings = splitSideStrings.first.split(",");
    final rightItemStrings = (splitSideStrings.length > 1)
        ? splitSideStrings.last.split(",")
        : <String>[];

    return WindowDecorationLayout(_getDecorationsFromStrings(leftItemStrings),
        _getDecorationsFromStrings(rightItemStrings));
  }

  static List<WindowDecoration> _getDecorationsFromStrings(
      List<String> strings) {
    final decorations = List<WindowDecoration>.empty(growable: true);
    for (final string in strings) {
      if (string.isNotEmpty) {
        final decoration = WindowDecoration.fromString(string);
        if (decoration != null) {
          decorations.add(decoration);
        }
      }
    }
    return decorations;
  }
}
