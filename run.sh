appid=2379780
log_dir="~/.steam/steam/steamapps/compatdata/$appid/pfx/drive_c/users/steamuser/AppData/Roaming/Balatro/Mods/lovely/log/"
log_dir_expanded=$(eval echo $log_dir)

start_time=$(date +%s)

steam steam://rungameid/$appid &

until find "$log_dir_expanded" -type f -name "*.log" -newermt @$start_time -print -quit | grep -q .; do
    sleep 1
done

recent_log=$(find "$log_dir_expanded" -type f -name "*.log" -print0 | xargs -0 ls -t | head -n 1)


echo $recent_log

tail -f "$recent_log"
