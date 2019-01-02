# Polybar Module - News

## Description
This [polybar](https://github.com/jaagr/polybar) module displays RSS feeds. Then You can read news in your browser by a simple click on the bar.

## Screenshots

<img alt="Screenshot of polybar module: news" src="screenshots/polybar-module-news.gif" width="860">

## Installation
Clone or download this repository, then run the following commands:
```
$ cd polybar-module-news  # directory where you cloned the repository or unzipped the release file
$ sh install.sh
```

Add your favorite RSS feeds to `~/.config/.polybar/scripts/news/rss.feeds`

Enable this module in your bar, e.g:
```

[bar/mybar]
...
modules-left = news ...
```

Finally, restart polybar.

## Dependencies
This script requires [bash](https://www.gnu.org/software/bash/), [rsstool](https://sourceforge.net/projects/rsstool/files/rsstool-1.0.0-linux.tar.gz/download) and [wget](https://www.gnu.org/s/wget/) for downloading data. You can alternately use Python feedparser instead of rsstool+wget (install it with `pip install --user feedparser`).

## Configuration
Edit the file `~/config/polybar/scripts/news/news.conf` and set up the right Python interpreter if you do not use rsstool.

You can change the interval between two headlines by editing the following file:
```
~/config/polybar/scripts/news/module.conf
```

## License
This software is licensed under the MIT license. See [LICENSE](LICENSE.md).
