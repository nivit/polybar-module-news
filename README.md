# Polybar Module - News

## Description
This [polybar](https://github.com/jaagr/polybar) module displays RSS/Atom feeds. So you can read news in your browser by a simple click on the bar.

## Screenshots

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
- [bash](https://www.gnu.org/software/bash/)
- [python](https://www.python.org) 3
- python module [feedparser](https://github.com/kurtmckee/feedparser) (install it with `pip3 install --user feedparser` or with your packages manager).

## Configuration
Edit the file `~/config/polybar/scripts/news/news.conf` and set up the right Python 3 interpreter.

You can change the interval between two headlines by editing the following file:
```
~/config/polybar/scripts/news/module.conf
```

## Running
Click on the news headline on the bar to open the relative web page in your browser.

## License
This software is licensed under the MIT license. See [LICENSE](LICENSE.md).
