 # GTK Window
A package that add some missing gtk4 windowing features to flutter. Works for linux but it can also work for MacOS and Windows.   

[![pub package](https://img.shields.io/pub/v/gtk_window.svg)](https://pub.dev/packages/gtk_window)  
  

Before            |  After
:-------------------------:|:-------------------------:
![](https://raw.githubusercontent.com/YoussefLasheen/gtk_window/main/images/before_1.png)  |  ![](https://raw.githubusercontent.com/YoussefLasheen/gtk_window/main/images/after_1.png)
![](https://raw.githubusercontent.com/YoussefLasheen/gtk_window/main/images/before_2.png)  |  ![](https://raw.githubusercontent.com/YoussefLasheen/gtk_window/main/images/after_2.png)



## Features

- Window Command buttons like Maximize, Minimize, and Close   
- Back button when there's a view that can be poped
- Custom leading and trailing widgets
- PreferedSize bottom widgets
- Light and Dark mode
- Headerbar reacts to the window focus state
- On window resize call allows you to add custom logic in reaction to the window resize
- Curved corners (thanks to [handy_window](https://pub.dev/packages/handy_window))

## Getting started
### Linux:   

To get rounded corners move the two lines to the end of the my_application_activate class
from:
```cc
gtk_window_set_default_size(window, 1280, 720);
//gtk_widget_show(GTK_WIDGET(window));
```
```cc
FlView* view = fl_view_new(project);
//gtk_widget_show(GTK_WIDGET(view));
gtk_container_add(GTK_CONTAINER(window), GTK_WIDGET(view));
```

to:
```cc
static void my_application_activate(GApplication* application) {
...

gtk_widget_show(GTK_WIDGET(window));
gtk_widget_show(GTK_WIDGET(view));
}
```
## Usage of GTKHeaderBar
It's a drop in replacment for the AppBar widget. So It allows you to just replace the Material with it for desktop clients.
### Basic title
```dart
import 'package:gtk_window/gtk_window.dart';
Scaffold(
    appBar: GTKHeaderBar(
        middle: Text('example title'),
      ),
)
```
### Basic title with overflow hamburger menu:
```dart
import 'package:gtk_window/gtk_window.dart';
Scaffold(
    appBar: GTKHeaderBar(
        middle: Text('example title'),
        trailing: ElevatedButton(
            child: Icon(child: Icons.menu,)
        ),
      ),
)
```
### Basic title with search bottom:
```dart
import 'package:gtk_window/gtk_window.dart';
Scaffold(
    appBar: GTKHeaderBar(
        middle: Text('Settings'),
        trailing: GTKButton(
            child: Icon(child: Icons.menu,)
        ),
        bottom: PreferredSize(
            preferredSize: const Size.fromHeight(48),
            child: TextField()
        )
      ),
)
```
### Complicated split view with bottom search_bar:

Check out this [fork](https://github.com/YoussefLasheen/settings/tree/2fa2cc63f19e4a15b57be24974276b7962b97992)

![](https://raw.githubusercontent.com/YoussefLasheen/gtk_window/main/images/example_settings.png)


## Current limitations
 - The OS doesn't treat the appbar natively so it can't be hidden in the case of using a window manager.
 - Currenlty right-clicking on the header does nothing.
## Why not just use the native headerbar provided by flutter?
Due to the wide array of supported platforms that the flutter team mantain, they have to bundle features together to work on as much platforms as they can to simplify development. So they made the GTK appbar version to be just like MacOS's and Windows' as they just hover over the content without having so muchcontrol over them. In GTK the appbar's can have lots of widgets contained in them, which without this package you would have no control over them.

## Disclaimer
I not very profecient with GTK itself and every suggestion is welcome.

## Used plugins
I actually didn't write any platform specific codes for this package. I relied on the amazing work done by handy_window and window_manager maintainers.