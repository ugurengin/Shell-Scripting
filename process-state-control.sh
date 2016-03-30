#!/bin/sh
# Check running process that it really still alive after wait in seconds.
# In this cause that a process could be stuck in bg, so we need to take action.

_pidcontrol () {

curpid=$(pgrep -f <process_name>)

if [ ! -n "$curpid" ]; then
     echo "Process already doesn't exist"
     break
else
     for i in {1..60}; do
     sleep 1
     x=1
 
     pgrep -f <process_name> > /dev/null 2>&1

     if [ "$?" -eq "$x" ]; then
          echo "Process is finished its role at os"
          break
     else
          v=60
          echo "Waiting for "$(( ($v - $i) + 1))" second to terminating process."
          y=$i

     if [ "$y" -eq "$v" ]; then
          kill <signal> $curpid
          #You can add other action that whenever you want to execute here.
     fi
fi
done
fi
}

_pidcontrol
