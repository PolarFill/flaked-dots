ps -ft tty(tty | sed 's/\/dev\/pts\///') | grep (whoami) | awk '{if(NR == 1){print $2}}'
