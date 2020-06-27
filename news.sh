#!/bin/sh
#
# title: Polybar Module - News
# project-home: https://github.com/nivit/polybar-module-news
# license: MIT

##################
# default values #
##################

show_menu="yes"  # show a menu of all news (via rofi)
rofi_prompt="find news"
rofi_options="-i"  # -i makes dmenu searches case-insensitive
show_site="yes"  # display the name of the source
use_colors="yes"  # for error/warning

# number of characters for the output
# zero means no limit
length=0  # a value >= 0
# used only when length > 0
add_ellipsis="yes"  # yes|no

error_bg_color="#F44336"
error_fg_color="#FFFFFF"
warning_bg_color="#FFC107"
warning_fg_color="#212121"

python_cmd=python3

################
# start script #
################

module_dir=${HOME}/.config/polybar/scripts/news
module_obj_dir=${module_dir}/obj

feed_file=${module_obj_dir}/news.items
menu_file=${feed_file}.menu
feeds=${module_dir}/rss.feeds
news_conf=${module_dir}/news.conf
rss_lock=${module_obj_dir}/news.lock
rss_py=${module_dir}/download_rss_feeds.py
rss_url=${module_obj_dir}/news.url


error_msg() {

    if [ "X${use_colors}X" = "XyesX" ]; then
        printf "%s" "%{B${error_bg_color} F${error_fg_color}} ${1} %{B- F-}"
    else
        printf "%s" "${1}"
    fi

    exit 0
}


warning_msg() {

    if [ "X${use_colors}X" = "XyesX" ]; then
        printf "%s" "%{B${warning_bg_color} F${warning_fg_color}} ${1} %{B- F-}"
    else
        printf "%s" "${1}"
    fi
}


download_rss() {

    if [ ! -f "${feeds}" ]; then
        error_msg "-- no feeds file found! --"
        exit 0
    fi

    if [ ! -d "${module_obj_dir}" ]; then
        mkdir -p "${module_obj_dir}"
    fi

    if command -v "$python_cmd" > /dev/null 2>&1; then
        if ! ${python_cmd} -c 'import feedparser' > /dev/null 2>&1; then
            error_msg "-- install python module feedparser, please! --"
            exit 0
        fi
    else
        error_msg "-- install/configure a python 3 interpreter, please! --"
    fi

    warning_msg "-- Downloading RSS/Atom feeds --"

    (
        touch "${rss_lock}"
        ${python_cmd} "${rss_py}" "${feeds}" "${feed_file}"
        cp -f "${feed_file}" "${menu_file}"
        rm "${rss_lock}"
    )

    exit 0
}


show_menu() {
    if [ ! -f "${menu_file}" ]; then
        error_msg "-- no news file found! --"
        exit 0
    fi

    choice="$(awk '{if (((NR-2) % 3) == 0) print $0}' "${menu_file}"| \
        rofi -p "${menu_prompt}" "${rofi_options}" -lines ${menu_lines} \
            -format d -dmenu)"

    if [ -n "${choice}" ]; then
        url="$(sed -n -e $((choice*3))p "${menu_file}")"
        xdg-open "${url}";
        exit 0
    fi

    exit 0
}


setup() {

    # override default values
    if [ -f "${news_conf}" ]; then
        # shellcheck source=news.conf disable=SC1091
        . "${news_conf}"
    fi

    if [ "X${show_menu}X" = "XyesX" ]; then
        if ! command -v rofi > /dev/null 2>&1; then
            error_msg "-- install rofi program, please! --"
            exit 0
        fi
    fi

    if ! command -v xdg-open > /dev/null 2>&1; then
        error_msg "-- install xdg-open program, please! --"
        exit 0
    fi
}


main() {

    if [ -s "${feed_file}" ]; then
        if [ -z "$1" ] && [ ! -f "${rss_lock}" ]; then
            if [ "X${show_site}X" = "XyesX" ]; then
                site=$(sed -n -e '1p' "${feed_file}")": "
            else
                site=""
            fi

            title=$(sed -n -e '2p' "${feed_file}")
            output="${site}${title}"

            if [ "${length}" -gt 0 ] && [ "${length}" -lt "${#output}" ]; then
                if [ "X${add_ellipsis}X" = "XyesX" ] ; then
                    ellipsis="..."
                    length="$((length - 3))"
                else
                    ellipsis=""
                fi
                output="$(printf "%s" "${output}" | cut -c -"${length}")"
                output="${output% *}${ellipsis}"
            fi

            url=$(sed -n -e '3p' "${feed_file}")

            printf "%s" "${url}" > "${rss_url}"
            sed -i.bak -e '1,3d' "${feed_file}"
            printf "%s" "${output}"

            exit 0
        elif [ "$1" = "url" ]; then
            xdg-open "$(cat "${rss_url}")"&
            exit 0
        elif [ "$1" = "download" ] && [ ! -f "${rss_lock}" ]; then
            download_rss
            exit 0
        elif [ "$1" = "show_menu" ] && [ ! -f "${rss_lock}" ]; then
            show_menu
            exit 0
        else
            warning_msg "-- Downloading RSS/Atom feeds --"
            exit 0
        fi
    else
        download_rss
    fi
}


setup
main "${1}"

# vim: expandtab shiftwidth=4 smartindent softtabstop=4 tabstop=4
