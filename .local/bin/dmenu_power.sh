#!/usr/bin/env bash
# dmenu script for power commands
# Author: Rafael Cavalcanti <https://rafaelc.org/dev>

readonly options="$(cat <<-END
	Restart dwm#killall -HUP dwm
	Logout#killall -TERM dwm
	Suspend#systemctl suspend
	Reboot#systemctl reboot
	Poweroff#systemctl poweroff
END
)"

readonly chosen="$(
	cut -d# -f1 <(printf "%s" "$options") |
	dmenu \
		-p "Power menu:" \
		"$@"
)"
[[ -z "$chosen" ]] && exit

readonly cmd="$(grep "$chosen" <(printf "%s" "$options") | cut -d# -f2)"
exec $cmd
