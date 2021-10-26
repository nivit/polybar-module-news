#!/bin/sh

# this script installs the polybar module news

module_version=3.0.0

polybar_dir=${polybar_dir:-${HOME}/.config/polybar}
destdir=${destdir:-${polybar_dir}/scripts/news}
polybar_conf=${polybar_conf:-${polybar_dir}/config}

now="$(date +%Y-%m-%dT%H:%M:%S)"

if [ ! -d "${destdir}" ]; then

  install -U -d "${destdir}"
  install -U -d "${destdir}/conf"
  install -U -b -m 644 ./*.conf ./*.rasi feeds_list* "${destdir}/conf"

  if [ -f "${polybar_conf}" ] && \
      ! /usr/bin/grep -q '^; \[module/news\]' "${polybar_conf}"; then
    cat polybar.conf >> "${polybar_conf}"
  else
    echo "-- Add the following lines to your polybar configuration --"
    cat polybar.conf
  fi
else  # update
  # backup all stuff
  cp -Rf "${destdir}" "${destdir}.${now}"
  echo "-- Backup copy created in ${destdir}.${now} --"

  install -U -d "${destdir}/conf"
  install -U -b -m 644 conf/feeds_list_breaking_news "${destdir}"/conf/

  if [ -f "${destdir}"/config.rasi ] &&
      [ ! -f "${destdir}/conf/config.rasi" ]; then
    sed -i '' -e 's,\(scripts/news\)\(/news-theme.rasi\),\1/conf\2,1' \
      "$(realpath "${destdir}"/config.rasi)"
    install -U -b -m 644 "${destdir}"/config.rasi "${destdir}"/conf/
  fi

  if [ -f "${destdir}"/module.conf ] &&
      [ ! -f "${destdir}"/module.conf ]; then
    install -U -b -m 644 "${destdir}"/module.conf "${destdir}"/conf/
  fi

  if [ -f "${destdir}"/news-theme.rasi ] &&
      [ ! -f "${destdir}"/conf/news-theme.rasi ]; then
    install -U -b -m 644 "${destdir}"/news-theme.rasi "${destdir}"/conf/
  fi

  if [ -f "${destdir}"/rss.feeds ] && \
      [ ! -f "${destdir}/conf/feeds_list" ]; then
    install -U -b -m 644 "${destdir}"/rss.feeds "${destdir}"/conf/feeds_list
  fi

  if [ -f "${destdir}"/news.conf ]; then
    install -U -b -m 644 "${destdir}"/news.conf "${destdir}"/conf/
    sed -i '' -e 's,\(scripts/news\)\(/config.rasi\),\1/conf\2,1' \
        -e 's,add\(_ellipsis\),use\1,1' \
        -e 's,menu\(_prompt\),search\1,1' \
        "$(realpath "${destdir}"/conf/news.conf)"
    if [ -f "updates/2.x.x_to_${module_version}.txt" ]; then
      cat updates/2.x.x_to_"${module_version}.txt" >> "${destdir}"/conf/news.conf
    fi
  fi

  if [ -f "${polybar_conf}" ]; then
    if ! /usr/bin/grep -q '^; \[module/news\]' "${polybar_conf}"; then
      cat polybar.conf >> "${polybar_conf}"
    else
      sed -i '' -e 's,\(scripts/news\)\(/module.conf\),\1/conf\2,1' \
        "$(realpath "${polybar_conf}")"
    fi
  fi
fi

install -U -m 554 ./*.py "${destdir}"
install -U -m 554 news.sh "${destdir}"

# clean up
rm -f "${destdir}"/download_rss_feeds.py
rm -f "${destdir}"/module.conf
rm -f "${destdir}"/news.conf
rm -f "${destdir}"/rss.feeds
rm -f "${destdir}"/news-theme.rasi
rm -f "${destdir}"/polybar.conf
rm -Rf "${destdir}"/obj

echo "-- Module news&podcast installed/updated! --"

# left over
echo "-- You can remove ${destdir}/config.rasi, if you want --"

