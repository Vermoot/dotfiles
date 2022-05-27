eww close menu
eww close menu-closer

eww update menu_shrunk=true

awesome-client 'client.focus = require("awful").mouse.client_under_pointer()'

menuW=200
menuH=300

eval $(xdotool getmouselocation --shell)
menuX=$X
menuY=$Y

if [ "$X" -gt $((1920 - menuW)) ]
then
  menuX=$(($X-$menuW))
fi

if [ "$Y" -gt $((1080 - $menuH)) ]
then
  menuY=$(($Y-$menuH))
fi

eww open menu-closer
eww open menu -p "${menuX}x${menuY}" -s "${menuW}x${menuH}"
eww update menu_shrunk=false
