# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    ls_check.sh                                        :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: mcabrol <mcabrol@student.42.fr>            +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2019/09/09 13:36:31 by mcabrol           #+#    #+#              #
#    Updated: 2019/09/10 18:33:17 by mcabrol          ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

#!/bin/bash
set +o posix

# Path to ft_ls
FTLS=~/Documents/ft_ls/ft_ls

# Log file
LOG=~/Documents/ft_ls
rm -f $LOG/log

# Regular Colors
Black='\033[0;30m'        # Black
Red='\033[0;31m'          # Red
Green='\033[0;32m'        # Green
Yellow='\033[0;33m'       # Yellow
Blue='\033[0;34m'         # Blue
Purple='\033[0;35m'       # Purple
Cyan='\033[0;36m'         # Cyan
White='\033[0;37m'        # White
EOC='\033[0m'             # Text Reset

# Check
if "$FTLS"
then
    printf "$Green-> ft_ls found.\n$EOC"
else
    printf "$Red-> ft_ls not found.\n$EOC"
    exit 0
fi

if valgrind -q "$FTLS"
then
    printf "$Green-> Valgrind found.\n$EOC"
    VAL=TRUE
else
    printf "$Red-> Valgrind not found.\n$EOC"
    VAL=FALSE
    exit 0
fi

printf "\n"

if [ "$1" == "disable-leak" ]
then
  VAL=FALSE
fi

# Commands
cmd=("Makefile" "author src" "--" "-a" "author Makefile src" "-l" "-la" "-l /Users" "-l /dev" "-l /var/run" "-l /tmp" "-l ~" "-l *" "-la" "-lR /dir"
     "-t" "-t /dir/abc" "-ta" "-tr" "-lt" "-ltar" "-ltRa" "-lrrrr" "-l -a -a")
     # "-a" "/" "-l /"
     # "-r" "-l -a -r -t --"
     # "-n" "--/" "-a -  -l--"
     # "-a -l" "-Rlla" "-R -r"
     # "-lll" "-RRRRRRR -t"
     # "-lan" "-- -l -a"
     # "-- ." "-, -l" "# ls"
     # "-R" "-arr" "-R ~/*"
     # "-aaaa" "dir" "-la dir" "-artR dir"
     # "-n" "-lR /dir"
     # "-n /dev"
     # "/Users"
     # "-l /var"
     # "-l /bin"
     # "/tmp"
     # "/dev"
     # "-lr"
     # "-- z" "-" "--" "---" "----" "-------" "- - -"
     # "---"
     # "--y"
     # "-----"
     # "-t -r"
     # "-t /abc"
     # "-1l1"
     # "-"
     # "-lrta"
     # "-xxx-"
     # "/abc ~"
     # "*"
     # "-nln"
     # "-atrltr dossier abc"
     # "-lllllr -l /var/run"
     # "-r -a -n /var/run"
     # "-lllllllllll -- a-")

# Print log
function print_log () {
  printf "$Purple[KO] test $sum\n$EOC" >> $LOG/log
  printf "$Yellow$FTLS $opt\n\n$EOC" >> $LOG/log
  printf "for more $Green#vimdiff <(ls -1 $opt) <($FTLS -1 $opt)$EOC\n" >> $LOG/log
  printf "$Blue------------------------\n$EOC" >> $LOG/log
}

# Test Dir
DIR=$LOG/dir

rm -rf $DIR
mkdir $DIR

mkdir $DIR/1 $DIR/2 $DIR/3 $DIR/A $DIR/B $DIR/C
mkdir $DIR/abc
mkfifo $DIR/fifo
mkfile -n 512k $DIR/xyz

touch -t 202003201000.10 $DIR/A/fd
touch -t 198010102045.33 $DIR/A/opt
touch -t 199912312359.59 $DIR/A/yr
touch -t 197012312359.59 $DIR/B/re
touch $DIR/B/.t $DIR/B/.t $DIR/B/.f
chmod 555 $DIR/A/*
chmod 754 $DIR/B/*
chmod 737 $DIR/C
chmod 777 $DIR/abc
mkfile -n 512k $DIR/C/fd
touch $DIR/abc/aa $DIR/abc/L $DIR/abc/129
touch $DIR/abc/bb $DIR/abc/R $DIR/abc/23
touch $DIR/abc/cc $DIR/abc/ZZ $DIR/abc/4555
touch $DIR/abc/dd $DIR/abc/B $DIR/abc/532
touch $DIR/abc/xx $DIR/abc/A $DIR/abc/1 $DIR/abc/uwefhwehfoweihfifwefhwv
touch $DIR/abc/gg $DIR/abc/V $DIR/abc/0 $DIR/abc/iwejoweihfwoehfwiegg
touch $DIR/abc/kk $DIR/abc/S $DIR/abc/4 $DIR/abc/wefiweofhwoefhgwiuegf


# Count
ok=0
ko=0
sum=0
PADDING=35
TMP=0

for i in "${cmd[@]}"
do
  if [ ${#i} -gt ${TMP} ]
  then
    TMP=${#i}
  fi
done

PADDING=$((TMP + 5))

for opt in "${cmd[@]}"
do
  DIFF=$(diff <(ls -1 $opt 2>&1) <($FTLS -1 $opt 2>&1))
  if [ "$VAL" == "TRUE" ]; then
    LEAKS=$(valgrind --leak-check=full --log-file="leak.log" "$FTLS" -1 $opt 2>&1)
    BYTES=$(cat leak.log | grep "definitely lost:" | awk {'print $4'})
    rm -f leak.log
  fi
  ((sum++))
  if [ "$DIFF" != "" ]
  then
    ((ko++))
    SDIFF=$(sdiff <(ls -1 $opt 2>&1) <($FTLS -1 $opt 2>&1))
    print_log "$opt" "$sum"
    printf "$Cyan$sum\t$Yellow$opt%-*s$Red[KO]$EOC" $((${#opt} - ${PADDING})) ""
    if [ "$VAL" == "TRUE" ]
    then
      if [ "$BYTES" != 0 ]
      then
        printf "$Red -> $BYTES bytes leaks$EOC"
      fi
    fi
    printf "\n"
  else
    ((ok++))
    printf "$Cyan$sum\t$Yellow$opt%-*s$Green[OK]$EOC" $((${#opt} - ${PADDING})) ""
    if [ "$VAL" == "TRUE" ]
    then
      if [ "$BYTES" != "0" ]
      then
        printf "$Red -> $BYTES bytes leaks$EOC"
      fi
    fi
    printf "\n"
  fi
done
printf "\n$Cyan$ko/$sum failed tests -> $LOG/log$EOC\n"

# Cleaning
rm -rf $DIR
rm -rf $LOG/leak.log
rm -rf $LOG/ft_ls.dSYM

exit 0
