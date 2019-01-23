# Polybar Module - News

## Description
This [polybar](https://github.com/jaagr/polybar) module displays RSS/Atom feeds, so you can read news in your browser by a simple click on the bar.

## Screenshot

<img alt="Screenshot of polybar module: news" src="screenshots/polybar-module-news.gif" width="860">

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

Configure the module (see below) and then restart polybar.

## Dependencies
This script requires
- [python](https://www.python.org) 3;
- python module [feedparser](https://github.com/kurtmckee/feedparser) (install it with `pip3 install --user feedparser` or with your package manager);
- [xdg-open](https://www.freedesktop.org/wiki/Software/xdg-utils/) (to open news link).

N.B. After installing Python 3 and/or feedparser you need to wait about 10 seconds before the error message of missing requirement disappears.

## Configuration
Edit the file `~/config/polybar/scripts/news/news.conf` and set up the right Python 3 interpreter.

Available options:

```
python_cmd=python3  # or python3.6, etc.

show_site="yes"  # display the name of the RSS/Atom source
use_colors="yes"  # for error/warning

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

You can change the interval between two headlines by editing the following file:
```
~/config/polybar/scripts/news/module.conf
```

## Running
Click on the news headline on the bar to open the relative web page in your browser.

## License
This software is licensed under the MIT license. See [LICENSE](LICENSE.md).
