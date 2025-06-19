#!/bin/bash

CHOICE=$(printf "Cancel\nHibernate\nPower Off\nReboot" | wofi --dmenu --width 200 --height 180 --prompt "Power")

case "$CHOICE" in
  Hibernate) systemctl hibernate ;;
  "Power Off") systemctl poweroff ;;
  Reboot) systemctl reboot ;;
  *) ;;
esac
