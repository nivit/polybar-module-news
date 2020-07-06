#!/bin/sh
#
# title: Polybar Module - News
# project-home: https://github.com/nivit/polybar-module-news
# license: MIT


##################
# default values #
##################

show_site="yes"  # display the name of the news source
use_colors="yes"  # for error/warning

show_menu="yes"  # show a menu with all news (via rofi, right click)
menu_prompt="Find news"
_menu_lines=15

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
feeds=${module_dir}/rss.feeds
menu_file=${feed_file}.menu
menu_scrollbar=true
news_conf=${module_dir}/news.conf
rofi_case=""  # case is sensitive
rofi_config=${module_dir}/config.rasi
rofi_list=${menu_file}.${show_site}
rofi_options=""
rofi_width=""  # "auto" or "" (menu width)
rss_lock=${module_obj_dir}/news.lock
rss_py=${module_dir}/download_rss_feeds.py
rss_url=${module_obj_dir}/news.url


print_msg() {

    if [ "X${use_colors}X" = "XyesX" ]; then
        if [ "${1}" = "warning" ]; then
            bg_color="${warning_bg_color}"
            fg_color="${warning_fg_color}"
        else
            bg_color="${error_bg_color}"
            fg_color="${error_fg_color}"
        fi
        printf "%s" "%{B${bg_color} F${fg_color}} -- ${2} -- %{B- F-}"
    else
        printf "%s" "${2}"
    fi

    if [ "${1}" = "error" ]; then
        exit 0  # actually ignore the error...
    fi
}

write_rofi_list() {
    # generate the list of news to show in rofi
    cp -f "${feed_file}" "${menu_file}"

    if [ -f "${feed_file}" ]; then
        awk -v show_site="${show_site}" '
            # ignore links to news
            NR % 3 == 0 {print $0; next}
            (NR-1) % 3 == 0 && (show_site == "yes") {printf "%s: ", $0}
            (NR-2) % 3 == 0
        ' "${menu_file}" > "${rofi_list}"
    fi
}


download_rss() {

    if [ ! -f "${feeds}" ]; then
        print_msg error "no feeds file found!"
    fi

    if [ ! -d "${module_obj_dir}" ]; then
        mkdir -p "${module_obj_dir}"
    fi

    if command -v "$python_cmd" > /dev/null 2>&1; then
        if ! ${python_cmd} -c 'import feedparser' > /dev/null 2>&1; then
            print_msg error "install python module feedparser, please!"
        fi
    else
        print_msg error "install/configure a python 3 interpreter, please!"
    fi

    print_msg warning "Downloading RSS/Atom feeds"

    (
        touch "${rss_lock}"
        ${python_cmd} "${rss_py}" "${feeds}" "${feed_file}"
        if [ "X${show_menu}X" = "XyesX" ]; then
            write_rofi_list
        fi
        rm -f "${rss_lock}"
    )

    exit 0
}

get_rofi_value() {
    # get a value from the rofi configuration.
    value="$(awk -v search="$1" '
    BEGIN {FS=":"; regex=sprintf("^[[:space:]]*%s:", search);}
        $0 ~ regex {gsub(/;|[ \t]+/, "", $2); printf "%s", $2; exit 0}
    ' "${rofi_config}")"

    echo "${value}"
}

show_menu() {
    # show a menu with all news (via rofi)
    if [ -f "${rss_lock}" ]; then
        rofi ${rofi_options} -e "Downloading RSS/Atom feeds"
        exit 0
    fi

    if [ ! -f "${menu_file}" ] || [ ! -f "${rofi_list}" ]; then
        write_rofi_list
    fi

    if [ -f "${rofi_config}" ]; then
        menu_width="$(get_rofi_value width)"

        if [ -z "${menu_width}" ] || [ "${menu_width#-}" != "${menu_width}" ] && \
            [ "${rofi_width}" = "auto" ]; then
            news_len="$(awk '
            NR % 2 == 1 {if (max < length()) { max = length()}}
            # return a negative value to indicate a character width
            # see rofi(1)
            END {print -max - 2}
            ' "${rofi_list}")"
            menu_width="${news_len}"
        fi

        menu_case="$(get_rofi_value case-sensitive)"

        if [ "${menu_case}" = "false" ]; then
            rofi_case="-i"
        fi
    fi

    if [ -n "$(echo "${menu_lines}" | tr -d "0-9")" ]; then
        # menu_lines is not a number
        menu_lines="$(get_rofi_value lines)"
    fi

    if [ -z "${menu_lines}" ]; then
        menu_lines=${_menu_lines}
    fi

    news_number="$(awk 'END {print NR/2}' "${rofi_list}")"

    if [ "${news_number}" -lt "${menu_lines}" ]; then
        menu_lines=${news_number}
        menu_scrollbar="false"
    fi

    choice="$(awk 'NR % 2 == 1' "${rofi_list}" | \
        rofi ${rofi_options} \
            -p "${menu_prompt}" \
            -dmenu \
            -format d \
            -lines "${menu_lines}" \
            "${rofi_case}" \
            -theme-str "*{scrollbar:${menu_scrollbar};}" \
            -width "${menu_width}")"

    if [ -n "${choice}" ]; then
        url="$(sed -n -e $((choice*2))p "${rofi_list}")"
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
        rofi_list=${menu_file}.${show_site}
    fi

    if [ "X${show_menu}X" = "XyesX" ]; then
        if ! command -v rofi > /dev/null 2>&1; then
            print_msg error "install rofi program, please!"
        fi
    fi

    if ! command -v xdg-open > /dev/null 2>&1; then
        print_msg error "install xdg-open program, please!"
    fi

    if [ -f "${rofi_config}" ]; then
        rofi_options="-config ${rofi_config}"
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
            print_msg warning "Downloading RSS/Atom feeds"
        fi
    else
        download_rss
    fi
}


setup
main "${1}"

# vim: expandtab shiftwidth=4 smartindent softtabstop=4 tabstop=4
