# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    run.sh                                             :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: mcabrol <mcabrol@student.42.fr>            +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2019/09/09 13:36:31 by mcabrol           #+#    #+#              #
#    Updated: 2019/09/23 18:15:23 by mcabrol          ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

#!/bin/bash
set +o posix

# Update
UP=$(git pull)

# Flags
N=TRUE
NORM=FALSE

# Path to ft_ls
FTLS=~/Documents/ft_ls/ls
ROOT=$(dirname $FTLS)

# Log file
LOG=$ROOT
rm -f $LOG/log
rm -f norm.log

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

# Set up option

if [ "$1" == "-leak" ]
then
  VAL=TRUE
else
  VAL=FALSE
fi

# Check
if "$FTLS"
then
    printf "$Green-> ft_ls found.\n$EOC"
else
    printf "$Red-> ft_ls not found.\n$EOC"
    make -C $ROOT
    if "$FTLS"
    then
      printf "$Green-> ft_ls found.\n$EOC"
    else
      printf "$Red-> ft_ls not found.\n$EOC"
      exit 0
    fi
fi

if [ "$1" == "-leak" ]
then
  if valgrind -q "$FTLS"
  then
      printf "$Green-> Valgrind found.\n$EOC"
      VAL=TRUE
  else
      printf "$Red-> Valgrind not found.\n$EOC"
      VAL=FALSE
  fi
else
  VAL=FALSE
fi

# if norminette
# then
#   printf "$Green-> Norminette found.\n$EOC"
#   NORM=TRUE
# else
#   printf "$Red-> Norminette not found.\n$EOC"
#   NORM=FALSE
# fi

NORM=FALSE

printf "\n"

# Commands
cmd=(" " "xxx" "dir" "dir xxx" "dir/A/fd dir/B" "dir/A dir/B dir/A/fd" "dir/A dir/B/re dir/abc/129 dir/abc" "dir/A dir/B/xx dir/abc/129 xxx"
	 "-R " "-R xxx" "-R dir" "-R dir xxx" "-R dir/A/fd dir/B" "-R dir/A dir/B dir/A/fd" "-R dir/A dir/B/re dir/abc/129 dir/abc" "-R dir/A dir/B/xx dir/abc/129 xxx"
	 "-l " "-l xxx" "-l dir" "-l dir xxx" "-l dir/A/fd dir/B" "-l dir/A dir/B dir/A/fd" "-l dir/A dir/B/re dir/abc/129 dir/abc" "-l dir/A dir/B/xx dir/abc/129 xxx"
	 "-a " "-a xxx" "-a dir" "-a dir xxx" "-a dir/A/fd dir/B" "-a dir/A dir/B dir/A/fd" "-a dir/A dir/B/re dir/abc/129 dir/abc" "-a dir/A dir/B/xx dir/abc/129 xxx"
	 "-r " "-r xxx" "-r dir" "-r dir xxx" "-r dir/A/fd dir/B" "-r dir/A dir/B dir/A/fd" "-r dir/A dir/B/re dir/abc/129 dir/abc" "-r dir/A dir/B/xx dir/abc/129 xxx"
	 "-t " "-t xxx" "-t dir" "-t dir xxx" "-t dir/A/fd dir/B" "-t dir/A dir/B dir/A/fd" "-t dir/A dir/B/re dir/abc/129 dir/abc" "-t dir/A dir/B/xx dir/abc/129 xxx"
	 "-n " "-n xxx" "-n dir" "-n dir xxx" "-n dir/A/fd dir/B" "-n dir/A dir/B dir/A/fd" "-n dir/A dir/B/re dir/abc/129 dir/abc" "-n dir/A dir/B/xx dir/abc/129 xxx"
	 "-Rlart " "-Rlart xxx" "-Rlart dir" "-Rlart dir xxx" "-Rlart dir/A/fd dir/B" "-Rlart dir/A dir/B dir/A/fd" "-Rlart dir/A dir/B/re dir/abc/129 dir/abc" "-Rlart dir/A dir/B/xx dir/abc/129 xxx"
	 "-tRlar " "-tRlar xxx" "-tRlar dir" "-tRlar dir xxx" "-tRlar dir/A/fd dir/B" "-tRlar dir/A dir/B dir/A/fd" "-tRlar dir/A dir/B/re dir/abc/129 dir/abc" "-tRlar dir/A dir/B/xx dir/abc/129 xxx"
	 "-Rlrta " "-Rlrta xxx" "-Rlrta dir" "-Rlrta dir xxx" "-Rlrta dir/A/fd dir/B" "-Rlrta dir/A dir/B dir/A/fd" "-Rlrta dir/A dir/B/re dir/abc/129 dir/abc" "-Rlrta dir/A dir/B/xx dir/abc/129 xxx"
	 "-Rlrtan " "-Rlrtan xxx" "-Rlrtan dir" "-Rlrtan dir xxx" "-Rlrtan dir/A/fd dir/B" "-Rlrtan dir/A dir/B dir/A/fd" "-Rlrtan dir/A dir/B/re dir/abc/129 dir/abc" "-Rlrtan dir/A dir/B/xx dir/abc/129 xxx"
	 "*"
	 "-l *"
	 "-lR *"
	 "-lart *"
	 "-n *"
	 "-l */*"
	 "-- /*"
	 "dir/*"
	 "dir/*/* . dir/P"
	 "-larR dir/*/* . dir/P"
	 "/Desktop"
	 "//Desktop xxxx"
	 "\"\" \"\""
	 "''"
	 "-t dir/A dir/B dir/A/fd"
	 "-r dir/A dir/B dir/A/fd"
	 "-rt dir/A dir/B dir/A/fd"
	 "-tr dir/A dir/B dir/A/fd"
	 "-lR ."
	 "-a" "-l" "/dev/tmp"
     "-R" "-" "/Library/" "/etc/resolv.conf"
     "-a /Users/" "-lat /dir" "-la /dev/tmp"
     "-z" "/System/Library/"
     "-n ~" "-rn ~" "-n /tmp"
     "-R" "-R dir"
     "-R ~" "-Ra ~" "-Rr ~" "-Rt ~" "-Rl" "-Rartl"
     "-n Makefile" "author src" "--" "-a" "author Makefile src" "-l" "-la"
     "-l /Users" "-l /dev" "-l /var/run" "-l /tmp" "-l ~" "-l *" "-la" "-lR /dir"
     "-t" "-t /dir/abc" "-ta" "-tr" "-lt" "-ltar" "-ltRa" "-lrrrr" "-l -a -a"
     "-a" "/" "-l /"
     "-r" "-l -a -r -t --"
     "-n" "--/" "-a -  -l--"
     "-a -l" "-Rlla" "-R -r"
     "-lll" "-RRRRRRR -t"
     "-lan" "-- -l -a"
     "-- ." "-, -l" "# ls"
     "-R" "-arr" "-R ~/*"
     "-aaaa" "dir" "-la dir" "-artR dir"
     "-n" "-lR /dir"
     "/Users"
     "-l /var"
     "-l /bin"
     "/tmp"
     "/dev"
     "-lr"
     "-- z" "-" "--" "---" "----" "-------" "- - -"
     "---"
     "--y"
     "-----"
     "-t -r"
     "-t /abc"
     "-1l1"
     "-"
     "-lrta"
     "-llz"
     "/abc ~"
     "-nln"
     "-lllllr -l /var/run"
     "-r -a -n /var/run"
     "-lllllllllll -- a-"
	 )

# Print log
function print_log () {
  printf "$Purple[KO] test $sum\n$EOC" >> $LOG/log
  printf "$Yellow$FTLS $opt\n\n$EOC" >> $LOG/log
  printf " $SDIFF\n\n" >> $LOG/log
  printf "for more $Green#vimdiff <(ls $opt) <($FTLS $opt)$EOC\n" >> $LOG/log
  printf "$Blue------------------------\n$EOC" >> $LOG/log
}

# Test Dir
DIR=dir

rm -rf $DIR
mkdir $DIR

mkdir $DIR/1 $DIR/2 $DIR/3 $DIR/A $DIR/B $DIR/C
mkdir $DIR/abc
mkfifo $DIR/fifo
mkfile -n 512k $DIR/xyz
mkdir $DIR/dir{1..5} $DIR/.hdir{1..5}
touch $DIR/dir1/file{1..5} $DIR/dir1/.hfile{1..5}
touch $DIR/.hdir1/file{1..5} $DIR/.hdir1/.hfile{1..5}
touch $DIR/.hdir1/file{1..5} $DIR/.hdir1/.hfile{1..5}
mkdir $DIR/abc/q
touch $DIR/abc/q/{a..z}
touch $DIR/abc/q/{0..500}
touch $DIR/k && ln -s $DIR/k $DIR/symlink
touch -amt 194010291036.32 $DIR/P
chmod -R +a "group:_www allow list,add_file,search,add_subdirectory,delete_child,readattr,writeattr,readextattr,writeextattr,readsecurity,file_inherit,directory_inherit" $DIR/p
touch -amt 999912312459.59 $DIR/l
chmod +t $DIR/l
touch -amt 202003201000.10 $DIR/A/fd
touch -amt 198010102045.33 $DIR/A/opt
touch -amt 199912312359.59 $DIR/A/yr
touch -amt 197012312359.59 $DIR/B/re
touch $DIR/B/.t $DIR/B/.t $DIR/B/.f
chmod 754 $DIR/B/*
chmod 737 $DIR/C
chmod 777 $DIR/abc
mkfile -n 512k $DIR/C/fd
touch $DIR/abc/aa $DIR/abc/L $DIR/abc/129
touch $DIR/abc/bb $DIR/abc/R $DIR/abc/23
touch $DIR/abc/cc $DIR/abc/ZZ $DIR/abc/4555
touch $DIR/abc/dd $DIR/abc/B $DIR/abc/532
touch $DIR/abc/xx $DIR/abc/A $DIR/abc/1 $DIR/abc/uwefhwehfoweihfifwefhwvwefiweofhwoefhgwiuegfwefiweofhwoefhgwiuegfwefiweofhwoefhgwiuegf
touch $DIR/abc/gg $DIR/abc/V $DIR/abc/0 $DIR/abc/iwejoweihfwoehfwieggwefiweofhwoefhgwiuegfwefiweofhwoefhgwiuegfwefiweofhwoefhgwiuegf
touch $DIR/abc/kk $DIR/abc/S $DIR/abc/4 $DIR/abc/wefiweofhwoefhgwiuegfwefiweofhwoefhgwiuegfwefiweofhwoefhgwiuegfwefiweofhwoefhgwiuegf

# Count
ok=0
ko=0
sum=0
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
  DIFF=$(diff -b <(ls $opt 2>&1) <($FTLS $opt 2>&1))
  if [ "$VAL" == "TRUE" ]; then
    LEAKS=$(valgrind --leak-check=full --log-file="leak.log" "$FTLS" -1 $opt 2>&1)
    BYTES=$(cat leak.log | grep "definitely lost:" | awk {'print $4'})
    rm -f leak.log
  fi
  ((sum++))
  if [ "$DIFF" != "" ]
  then
    ((ko++))
    SDIFF=$(sdiff <(ls $opt 2>&1) <($FTLS $opt 2>&1))
    print_log "$opt" "$sum" "$SDIFF"
    printf "$Cyan$sum\t$Yellow ./ft_ls $opt%-*s$Red[KO]$EOC" $((${#opt} - ${PADDING})) ""
    if [ "$VAL" == "TRUE" ]
    then
      if [ "$BYTES" != 0 ]
      then
        printf "$Red [KO]$EOC"
        printf "$Red -> $BYTES bytes leaks$EOC"
      else
        printf "$Green [OK]$EOC"
      fi
    fi
    printf "\n"
  else
    ((ok++))
    printf "$Cyan$sum\t$Yellow ./ft_ls $opt%-*s$Green[OK]$EOC" $((${#opt} - ${PADDING})) ""
    if [ "$VAL" == "TRUE" ]
    then
      if [ "$BYTES" != "0" ]
      then
        printf "$Red [KO]$EOC"
        printf "$Red -> $BYTES bytes leaks$EOC"
      else
        printf "$Green [OK]$EOC"
      fi
    fi
    printf "\n"
  fi
done
printf "\n$Cyan$ko/$sum failed tests -> $LOG/log$EOC\n"

# Norminette
if [ "$NORM" == "TRUE" ]
then
  echo -ne '#####                     (33%)\r'
  CFILES=$(find $ROOT -type f -name "*.c")
  HFILES=$(find $ROOT -type f -name "*.h")
  CIFILES=$(echo "$CFILES" | wc -l | awk '{print $1}')
  HIFILES=$(echo "$HFILES" | wc -l | awk '{print $1}')
  TOTALFILES=$((${CIFILES} + ${HIFILES}))
  norminette $HFILES >> norm.log
  echo -ne '#############             (66%)\r'
  norminette $CFILES >> norm.log
  if [ -s norm.log ]
  then
    echo -ne '#######################   (100%)\r'
    echo -ne '\n'
    printf "$Cyan$TOTALFILES files ($CIFILES .c, $HIFILES .h)\t$Yellow Norminette%-*s$Red[KO]$EOC\n" $((${#opt} - ${PADDING})) ""
    cat norm.log | grep Error -B1
  else
    echo -ne '#######################   (100%)\r'
    echo -ne '\n'
    printf "$Cyan$TOTALFILES files ($CIFILES .c, $HIFILES .h)\t$Yellow Norminette%-*s$Green[OK]$EOC\n" $((${#opt} - ${PADDING})) ""
  fi
fi

printf "\n"

# Cleaning
rm -rf $DIR
rm -rf $LOG/leak.log
rm -rf $LOG/ft_ls.dSYM

exit 0
