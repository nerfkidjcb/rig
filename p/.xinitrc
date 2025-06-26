feh --bg-scale .config/wallpaper.png &

xset s off
xset -dpms
xset s noblank

xinput --set-prop 13 "libinput Accel Speed" -0.65

dwmblocks &
exec dwm
