# Polybar Module - News & Podcasts

## Description
This [polybar](https://github.com/jaagr/polybar) module displays news and
podcast titles, so you can read/listen to them in your browser/audio|video
player with a simple click on the bar.
You can also search/choose a specific news/podcast through a menu (via
[rofi](https://github.com/adi1090x/rofi)) opened by a keyboard shortcut.


## Screenshot

<figure>
<img alt="Animated gif of the menu with all news" src="screenshots/polybar-module-news-menu.gif" width="860">
<figcaption>The menu with all news opened above the bar</figcaption>
</figure>

## Installation/Update
Clone (or [download](https://github.com/nivit/polybar-module-news/releases)) this repository:

```
git clone https://github.com/nivit/polybar-module-news.git
```

then run the following commands:

```
$ cd polybar-module-news  # directory where you cloned the repository or unzipped the release file
$ sh install.sh
```

Add links of your favorite news/podcast sites to

`~/.config/.polybar/scripts/news/conf/feeds_list`

and/or to

`~/.config/.polybar/scripts/news/conf/feeds_list_breaking_news`

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
- python module [feedparser](https://github.com/kurtmckee/feedparser) (install
it with `pip3 install --user feedparser` or with your package manager);
- [xdg-open](https://www.freedesktop.org/wiki/Software/xdg-utils/) (to open news
link);
- [rofi](https://github.com/davatorium/rofi) (optional dependency to show a menu
with all news);
- an audio/video player (optional dependency) to open podcast files.

N.B. After installing Python 3 and the other dependencies you need to wait about
10 seconds before the error message of missing requirement disappears.

## Configuration
Edit the file `~/.config/polybar/scripts/news/conf/news.conf` and set up the
right Python 3 interpreter.

All available options:


| name             | description                                                                                             | default value                                         |
| ---------------- | ------------------------------------------------------------------------------------------------------- | ----------------------------------------------------- |
| quiet_mode       | no output if there are no news/podcasts titles                                                          | no                                                    |
| show_site        | show the name of the site as prefix to the title                                                        | yes                                                   |
| show_date        | show the news date, if available                                                                        | yes                                                   |
| date_as_prefix   | show the date before the title (otherwise as suffix), if show_date=yes                                  | yes                                                   |
| date_format      | see manpage strftime(3) for the conversation specs.                                                     | %d %b. %R -                                           |
| show_prefix      | show icon, date and site name                                                                           | yes                                                   |
| news_prefix      | the prefix to show before the title                                                                     | the character U+F09E                                  |
| use_colors       | for news/podcast title and diagnostic messages                                                          | yes                                                   |
| colors           | a list of colors, separated by spaces or commas, to use for the news titles                             | #28FFBF #FFEF78 #49FF00                               |
| error_bg_color   | background color for error messages                                                                     | #F44336                                               |
| error_fg_color   | foreground color for error messages                                                                     | #FFFFFF                                               |
| warning_bg_color | background color for warning messages                                                                   | #FFC107                                               |
| warning_fg_color | foreground color for the warning messages                                                               | #212121                                               |
| reverse_order    | reverse the order of the news in the search list                                                        | yes                                                   |
| show_menu        | display a menu with all news (via rofi, right click)                                                    | yes                                                   |
| menu_lines       | number of news to show in the menu, definible also in config.rasi, (height of menu)                     | 20                                                    |
| media_link       | use link to a multimedial file if available                                                             | yes                                                   |
| audio_player     | program to open audio files of podcast                                                                  | gmplayer                                              |
| video_player     | program to open video files of podcast                                                                  | mpv                                                   |
| audio_prefix     | prefix for the audio titles                                                                             |  U+F2CE (audio)                                      |
| video_prefix     | prefix for the video titles                                                                             |  U+F144 (video)                                      |
| search_prompt    | string to use as search prompt                                                                          | "Search"                                              |
| max_news         | max number of news per feed (a whole number or 0 for all news). It takes effect with the next download. | 0                                                     |
| length           | number of characters for the output to the bar; zero means no limit                                     | 0                                                     |
| use_ellipsis     | add ... where the title length is > 0                                                                   | yes                                                   |
| open_cmd         | program for opening URLs                                                                                | xdg-open                                              |
| breaking_news    | enable breaking news (see below)                                                                        | yes                                                   |
| rofi_config      | path to the rofi configuration file                                                                     | ${HOME}/.config/polybar/scripts/news/conf/config.rasi |
| rofi_width       | width of the rofi menu (see rofi(1))                                                                    | auto                                                  |
| python_cmd       | a python 3 interpreter                                                                                  | python3                                               |


You can change the interval between two headlines by editing the relative option
in the following file:
```
~/.config/polybar/scripts/news/conf/module.conf
```

To configure the menu you can edit the file ``` ~/.config/polybar/scripts/news/conf/config.rasi```.

## Breaking News Configuration
Add the feed URL of the breaking news sites to

`~/.config/polybar/scripts/news/conf/feeds_list_breaking_news`

then, in your terminal, run the command:

`crontab -e`

and add the following line:

`*/5 * * * * /usr/bin/python3 $HOME/.config/polybar/scripts/news/download_feeds.py -c '#0cffc8,#cae970' -l 5 $HOME/.config/polybar/scripts/news/data`

then save and exit the editor.

Change the list of colors after the `-c` option, and the number of minutes after
the first slash and the option `-l`, if you want.

Change the value of the variable breaking_news to "yes" in the configuration file:

```
~/.config/polybar/scripts/news/conf/news.conf
```

When the headlines are available, they take immediately precedence over other
news.

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

You can also open the current news with a keyboard shortcut by binding the
following command:

```
$HOME/.config/polybar/scripts/news/news.sh open
```

To select the feeds at runtime, you can bind the following command to a keyboard
shortcut or run it from a terminal:

```
$HOME/.config/polybar/scripts/news/news.sh select
```

You can always force a download with the command:

```
$HOME/.config/polybar/scripts/news/news.sh download
```

## Notes
1. The feed URL of a site is generally available at `/feed/` address, but you
can also find it by searching for an RSS icon in the page or viewing its HTML
page source. You may also use the [Ukora news
search](https://www.rsssearchhub.com) engine;
2. in the feed title the tag `[BN]` marks a breaking news site;
3. see the site https://colorhunt.co/palettes or https://colorswall.com/ for some
hint of colors;
4. to see icons you need to install a suitable font like Font Awesome;
5. as video player you could consider the program
[umpv](https://github.com/mpv-player/mpv/blob/master/TOOLS/umpv).
6. if you think this script is useful, add a star to the repository, please!
:wink:

## License
This software is licensed under the MIT license. See [LICENSE](LICENSE.md).

