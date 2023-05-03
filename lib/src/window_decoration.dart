enum WindowDecoration {
  close,
  minimize,
  maximize;

  static WindowDecoration? fromString(String decString) {
    switch (decString) {
      case "close":
        return close;
      case "minimize":
        return minimize;
      case "maximize":
        return maximize;
      default:
        return null; // anything else is not supported, including "icon" and "menu"
    }
  }
}
