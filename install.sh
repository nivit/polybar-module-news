#!/bin/sh

# this script installs the polybar module news

destdir=${HOME}/.config/polybar/scripts/news
polybar_conf=${HOME}/.config/polybar/config

install -d "${destdir}"
install -m 554 news.sh "${destdir}"
install -b -m 644 ./*.py "${destdir}"

if [ "${1}" != "update" ]; then
  install -b -m 644 ./*.conf ./*.rasi rss.feeds "${destdir}"
  if [ -f "${polybar_conf}" ]; then
      cat polybar.conf >> "${polybar_conf}"
  else
      echo "Add the following lines to your polybar configuration:"
      cat polybar.conf
  fi
fi
