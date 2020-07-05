# Polybar Module - News

## Description
This [polybar](https://github.com/jaagr/polybar) module displays RSS/Atom feeds,
so you can read news in your browser by a simple click on the bar.
You can also find/choose a specific news by a menu (via rofi) opened by
a keyboard shortcut.

## Screenshots

<figure>
<img alt="Screenshot of polybar module: news" src="screenshots/polybar-module-news.gif" width="860">
<figcaption>The module news on polybar</figcaption>
</figure>

<figure>
<img alt="Animated gif of the menu with all news" src="screenshots/polybar-module-news-menu.gif" width="860">
<figcaption>The menu with all news opened above the bar</figcaption>
</figure>

## Installation
Clone or download this repository, then run the following commands:
```
$ cd polybar-module-news  # directory where you cloned the repository or unzipped the release file
$ sh install.sh
```

Add your favorite RSS/Atom feeds to `~/.config/.polybar/scripts/news/rss.feeds`

Enable this module in your bar, e.g:
```

[bar/mybar]
...
modules-left = news ...
```

(It is advisable to use a whole bar for this module only).

Configure the module (see below) and then restart polybar.

## Dependencies
This script requires
- [python](https://www.python.org) 3;
- python module [feedparser](https://github.com/kurtmckee/feedparser) (install it with `pip3 install --user feedparser` or with your package manager);
- [xdg-open](https://www.freedesktop.org/wiki/Software/xdg-utils/) (to open news link);
- [rofi](https://github.com/davatorium/rofi) (optional dependency to show a menu with all news).

N.B. After installing Python 3 and/or feedparser/rofi you need to wait about 10 seconds before the error message of missing requirement disappears.

## Configuration
Edit the file `~/.config/polybar/scripts/news/news.conf` and set up the right Python 3 interpreter.

All available options:

```
python_cmd=python3  # or python3.6, etc.

show_site="yes"  # display the name of the RSS/Atom source
use_colors="yes"  # for error/warning

# show a menu of all news (via rofi)
# the menu is activated by a right-click on the bar
show_menu="yes"
# number of news to show in the menu
# you can also define it in config.rasi
menu_lines="20"
menu_prompt="Find news"
rofi_config="${HOME}/.config/polybar/scripts/news/config.rasi"
rofi_width="auto"  # (auto or empty)  # see rofi(1)

# number of characters for the output
# zero means no limit
length=0
# used only when the title is shortened, i.e when length > 0
add_ellipsis="yes"

# default colors for error/warning
error_bg_color="#F44336"
error_fg_color="#FFFFFF"
warning_bg_color="#FFC107"
warning_fg_color="#212121"
```

You can change the interval between two headlines by editing the relative option
in the following file:
```
~/.config/polybar/scripts/news/module.conf
```

To configure the menu you can edit the file ``` ~/.config/polybar/scripts/news/config.rasi```.

## Running
Click on the news headline on the bar to open the relative web page in your
browser.
With a right click on the bar you can open a menu with all news. You may also
show that menu by defining a key shortcut. The command to bind is:
```
~/.config/polybar/scripts/news/news.sh show_menu
```

For example, for [bspwm](https://github.com/baskerville/bspwm)/[sxhkd](https://github.com/baskerville/sxhkd),
you can add these lines to `~/.config/sxhkd/sxhkdrc`:

```
super + ctrl + shift + r
    $HOME/.config/polybar/scripts/news/news.sh show_menu
```

or for [i3wm](https://i3wm.org/) this line to `~/.config/i3/config`:

```
bindsym Mod4 + Control + Shift + r exec --no-startup-id ~/.config/polybar/scripts/news/news.sh show_menu
```

## License
This software is licensed under the MIT license. See [LICENSE](LICENSE.md).
