[

# 
# /etc/profile LOADs /etc/profile.local
# So, DO NOT FORGET TO TYPE
#
# $ sudo ln -s /your/local/env/file /etc/profile.local
# 

# MINUTE HOUR DD MM DAY ghasshee . /etc/profile COMMAND
 
# CHIME
" 0 6-22 * * * 	ghasshee . /etc/profile; $DOT/.bin/talking-clock"
 
# CAFE MUSIC
"20 11 * * 0-5 	ghasshee . /etc/profile; ~/.bin/bgm cafe 600 30 "
"1 15 * * 0-5 	ghasshee . /etc/profile; ~/.bin/bgm cafe 600 30 "

# FRENCH NHK
"0  5 * * 1-5 	ghasshee . /etc/profile; killall firefox"
"30 7 * * 1-5 	ghasshee . /etc/profile; sleep 32; ~/.bin/nhk-radio"
"30 7 * * 1-3	ghasshee . /etc/profile; sleep 30; ffmpeg -y -f pulse -i $AUDIO_OUT -t 905 ~/nhk/french/french_basical_$(date -I|sed s/-//g).ogg "
"30 7 * * 4-5	ghasshee . /etc/profile; sleep 30; ffmpeg -y -f pulse -i $AUDIO_OUT -t 905 ~/nhk/french/french_applied_$(date -I|sed s/-//g).ogg "
"0 11 * * 1-5 	ghasshee . /etc/profile; sleep 32; ~/.bin/nhk-radio"
"0 11 * * 1-3 	ghasshee . /etc/profile; sleep 35; ffmpeg -y -f pulse -i $AUDIO_OUT -t 905 ~/nhk/french/french_basical_RE_$(date -I|sed s/-//g).ogg"
"0 11 * * 4-5   ghasshee . /etc/profile; sleep 35; ffmpeg -y -f pulse -i $AUDIO_OUT -t 905 ~/nhk/french/french_applied_RE_$(date -I|sed s/-//g).ogg"

# ENGLISH NHK
"45 6 * * 1-5 	ghasshee . /etc/profile; sleep 30; ~/.bin/nhk-radio"
"25 12 * * 1-5 	ghasshee . /etc/profile; sleep 30; ~/.bin/nhk-radio"
"25 12 * * 1-5	ghasshee . /etc/profile; sleep 30; ffmpeg -y -f pulse -i $AUDIO_OUT -t 905 ~/nhk/english/english_onishi_$(date -I|sed s/-//g).ogg "

/*
# SLEEP TIMER
"1 22 * * 0-6 	ghasshee . /etc/profile; killall smplayer"
"1 22 * * 0-6 	ghasshee . /etc/profile; killall firefox"
"1 22 * * 0-6 	ghasshee . /etc/profile; killall chromium"
"1 22 * * 0-6 	ghasshee . /etc/profile; killall album ffplay"
"1 22 * * 0-6 	ghasshee . /etc/profile; sleep 2; ~/.bin/bgm sleep 1800 20"
"1 22 * * 0-6 	ghasshee . /etc/profile; amixer -q sset 'Master' 70%"
"25 22 * * 0-6 	ghasshee . /etc/profile; amixer -q sset 'Master' 60%"
"45 22 * * 0-6 	ghasshee . /etc/profile; amixer -q sset 'Master' 50%"
"0 23 * * 0-6 	ghasshee . /etc/profile; amixer -q sset 'Master' 40%"
"10 23 * * 0-6 	ghasshee . /etc/profile; amixer -q sset 'Master' 30%"
"25 23 * * 0-6 	ghasshee . /etc/profile; amixer -q sset 'Master' 20%"
"0 6 * * 0-6 	ghasshee . /etc/profile; amixer -q sset 'Master' 70%"
"0 7 * * 0-6 	ghasshee . /etc/profile; amixer -q sset 'Master' 75%"
"0 8 * * 1-5 	ghasshee . /etc/profile; ~/.bin/skynews"
*/

# GOMI DESU
"30 22 * * 1,4 	ghasshee . /etc/profile; for i in $(seq 1 30); do espeak 'asheetaaahhh --- Gohhmee - no he - dead su ';done"
"30 22 * * 3	ghasshee . /etc/profile; for i in $(seq 1 30); do espeak 'asheetaaahhh --- dann ball - no he - dead su ';done"

]
