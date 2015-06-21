#!/bin/sh
# MySQL Master-Slave Replication Data Consistency
 
thread=4
chunk_time=5
sleep=2
user=<user>
pass=<pass>
db=<db_name>
master_host=<master_ip>
slave_host=<slave_ip>
mysql=/usr/local/mysql/bin/mysql
checksum_table=percona.checksums
tmpfile=/tmp/small_tables_sync.out
ignore_tbl=large_table1,large_table2
email=email@domainname
 
# Checking the slave database to got its alive !
   for slave_check in $($mysql -u<user> -p<pass> -e "show slave status\G;"|egrep "Slave_IO_Running|Slave_SQL_Running"|awk {'print $2'});
     do
          if [ "$slave_check" != "Yes" ]; then
             echo "Process is termimated because of slave IO is not working!"
             exit 1
 
          elif [ "$slave_check" != "Yes" ]; then
             exit 1
             echo "Process is termimated because of slave SQL is not working!"
          fi
     done
 
# Doing checksum on tables for consistency.
/usr/bin/pt-table-checksum --quiet --max-load=Threads_running:$thread \
--user=$user --password=$pass --host=$master_host -d $db --chunk-time=$chunk_time \
--replicate $checksum_table --ignore-tables=$ignore_tbl > /dev/null 2>&1
  
        if [ $? -eq '0' ]
            then
            echo "OK: DB Replication is consist."
            exit 0
        else
            echo "Warning: DB Replication is not consist.Sync process is starting…”
 
# Detecting the difference data in tables.
echo -e "Detected some tables have inconsistency,\nbut all tables are succesfull synced." > $tmpfile
echo "DB.Table      Row Counts" >> $tmpfile
 
/usr/bin/pt-table-checksum --quiet --max-load=Threads_running:$thread \
--user=$user --password=$pass --host=$master_host -d $db --chunk-time=$chunk_time \
--replicate $checksum_table  --ignore-tables=$ignore_tbl --replicate-check-only| sed '1,2d'|sed '/../!d' >>$tmpfile
 
        if [ $? -ne '0' ]
            then
            echo "Process is terminated due to replicate checking problem"
            exit 1
        else
 
# Starting sync process
tables=`/bin/cat $tmpfile|cut -d ' ' -f 1|paste -s -d','`
 
/usr/bin/pt-table-sync --sync-to-master h=$slave_host,u=$user,p=$pass --databases=$db --table=$tables --execute
/bin/mail -s "DB Incosistency Problem" $email < $tmpfile
/bin/rm -f $tmpfile
 
       fi
fi
