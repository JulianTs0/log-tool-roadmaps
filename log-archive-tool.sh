#!/bin/bash

if test $# -eq 0
then
 echo "AN ARGUMENT IS MISSING, PLEASE PROVIDE A LOG DIRECTORY"
 exit
elif test $# -gt 1
then
  echo "A SINGLE ARGUMENT MUST BE PROVIDED WITH THE LOG DIRECTORY"
  exit
fi

if !(test -d $1)
then
  echo "THE ARGUMENT MUST BE A LOG DIRECTORY"
  exit
fi

logs=`ls $1 | grep  "\.log"`
dirs=`ls -l /var/log | grep ^d | tr -s " " | cut -d " " -f9 | tr "\n" " "`

if test `echo $logs | wc -w` -eq 0
then
  echo -e "THE LOG DIRECTORY DOES NOT HAVE  A SINGLE .log FILE, NOTHING TO ARCHIVE\nRETURNING TO THE TERMINAL"
  exit
fi

mkdir ./.aux_dir

echo "DO YOU WANT TO ARCHIVE THE LOGS IN THE SUBDIRECTORIES OF THE $1 [S/n]"

while true
do
  read opt 
  case $opt in
    S | s)

      for j in $dirs
      do
        echo $j
        dirs_log=`ls $1/$j | grep "\.log"`
        for k in $dirs_log
        do
          cp $1/$j/$k ./.aux_dir
        done
      done
    break
    ;;
    N | n) 

      echo -e "\nOK, CONTINUING WITH THE ARCHIVING PROCESS\n"
      break
    ;;
    *) 
      echo -e "\nPLEASE, ENTER A VALID OPTION [S/n]"
    ;;
  esac
done
  
for i in $logs
do
  cp $1/$i ./.aux_dir
done

actual_date=`date +%Y%m%d_%H%M%S`
mkdir -p "$1/logs_dir" && tar -cvzf "$1/logs_dir/logs_archive_$actual_date.tar.gz" "./.aux_dir"
rm -r ./.aux_dir
