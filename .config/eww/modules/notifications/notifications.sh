tiramisu -o "#summary"| while read -r line; do
eww update noti="$line"
eww open notification
sleep 3
eww close notification
done
