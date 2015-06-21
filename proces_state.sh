#!/bin/sh
proc=`ps -ef | grep process_name|grep -v "grep" | head -n 1 | awk '{print $1}'`
proc_state=`/bin/grep "State" /proc/$proc/status 2> /dev/null |awk {'print $2'}`
msg="process"
 
      if [ -z "${proc}" ]; then
        echo "$msg doesn't exist!"
        exit 1
      elif  [ "$proc_state" == "T" ] || [ "$proc_state" == "Z" ] || [ "$proc_state" == "D" ]; then
        echo "$msg is problematic.Process Status: $proc_state"
        exit 1
             else
          echo "$msg is running."
        exit 0
fi
