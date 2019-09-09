#!/bin/bash
set +o posix

# Log file
LS=~/Documents/ft_ls
rm -f $LS/log

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


# Commands
cmd=("-l" "-lo" "p0"
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
     "-n /dev"
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
     "-xxx-"
     "/abc ~"
     "*"
     "-nln"
     "-atrltr dossier abc"
     "-lllllr -l /var/run"
     "-r -a -n /var/run"
     "-lllllllllll -- a-")

# Print log
function print_log () {
  printf "$Purple[KO] test $sum\n$EOC" >> $LS/log
  printf "$Yellow./ft_ls $opt\n\n$EOC" >> $LS/log
  printf "$SDIFF\n\n" >> $LS/log
  printf "for more $Green#vimdiff <(ls -1 $opt) <(./ft_ls -1 $opt)$EOC\n" >> $LS/log
  printf "$Blue------------------------\n$EOC" >> $LS/log
}

# Test Dir
DIR=$LS/dir

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

for opt in "${cmd[@]}"
do
  DIFF=$(diff <(ls -1 $opt 2>&1) <(./ft_ls -1 $opt 2>&1))
  LEAKS=$(valgrind --leak-check=full --log-file="leak.log" ./ft_ls -1 $opt 2>&1)
  BYTES=$(cat leak.log | grep "definitely lost:" | awk {'print $4'})
  ((sum++))
  if [ "$DIFF" != "" ]
  then
    ((ko++))
    SDIFF=$(sdiff <(ls -1 $opt 2>&1) <(./ft_ls -1 $opt 2>&1))
    print_log "$SDIFF" "$opt" "$sum"
    printf "$Cyan$sum\t$Yellow$opt%-*s$Red[KO]$EOC" $((${#opt} - ${PADDING})) ""
    if [ ${BYTES} != 0 ]; then printf "$Red -> $BYTES bytes leaks$EOC"; fi
    printf "\n"
  else
    ((ok++))
    printf "$Cyan$sum\t$Yellow$opt%-*s$Green[OK]$EOC" $((${#opt} - ${PADDING})) ""
    if [ ${BYTES} != 0 ]; then printf "$Red -> $BYTES bytes leaks$EOC"; fi
    printf "\n"
  fi
done
printf "\n$Cyan$ko/$sum failed tests -> $LS/log$EOC\n"

rm -rf $DIR
exit 0
