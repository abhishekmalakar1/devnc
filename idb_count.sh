#!/bin/bash

# Author: Abhishek Malakar
# Description: DnR integrations IDB/SDB count monitoring script
# +------------------------------------------+
# 2022-10-12    abma0622  

export SCRIPT_NAME=$(basename $0)
STATE_OK=0
STATE_WARNING=1
STATE_CRITICAL=2
STATE_UNKNOWN=3
ICINGA_STATUS=$STATE_OK

ON=1
OFF=0
ERR=$OFF
fl=$OFF

usage()
{
  cat 1>&2 << EOF
USAGE: ${SCRIPT_NAME} <OPTIONS>
<OPTIONS> are the following:
  -c <connect string>   - db_user/db_user_pass@db_host:port/sid
  -d <idb name>         - idb table name
  -h                    - help on the usage

Examples:
${SCRIPT_NAME} -c 'NC_MONITORING/nc_monitoring_pass@vhtmadb01bp1.gmsw.netcracker.com:1524/VHTMA1' -d 'IDB_HFC%'
EOF
}

if [[ $# -ne 4 ]]; then
    echo  "Too many less arguments, expecting more." >&2
    usage;
    exit $ICINGA_STATUS
fi

while getopts ":c:d:" opt
  do
    case $opt in
      c ) CONNECT_STRING="${OPTARG}";;
      d ) DB="${OPTARG}";;
      * ) usage; exit;;
    esac
done

chk=`echo $DB |sed 's/%/-/g'`
current_date=$(date +%d-%m-%Y)
yesterday_date=$(date -d "yesterday" +%d-%m-%Y)

find /u01/app/monitoring/nc_nrpe/bin/mso/ -type f -name 'db_status_*' -mtime +1 -exec rm {} \;  #deleting old files

if [[ "$DB" = "IDB_PNI%" ]]; then

query=`$ORACLE_HOME/bin/sqlplus -S ${CONNECT_STRING} << EOD

set feedback off
set heading off
set linesize 120
select DECODE(rownum, 1, '', ' UNION ALL ') || 'SELECT ''' || table_name || ''' AS TABLE_NAME, COUNT(*) ' || ' FROM ' || table_name as query_string from all_tables where table_name like '${DB}';
exit;

EOD`

p1=`echo $query|sed 's/UNION/\n&/g'|sed -n '1,11p'|sed '1 s/UNION ALL //'|sed '$ s/$/;/'`
p2=`echo $query|sed 's/UNION/\n&/g'|sed -n '12,22p'|sed '1 s/UNION ALL //'|sed '$ s/$/;/'`
p3=`echo $query|sed 's/UNION/\n&/g'|sed -n '23,33p'|sed '1 s/UNION ALL //'|sed '$ s/$/;/'`
p4=`echo $query|sed 's/UNION/\n&/g'|sed -n '34,44p'|sed '1 s/UNION ALL //'|sed '$ s/$/;/'`
p5=`echo $query|sed 's/UNION/\n&/g'|sed -n '45,55p'|sed '1 s/UNION ALL //'|sed '$ s/$/;/'`

DB=`echo $DB |sed 's/%/-/g'`
table=`$ORACLE_HOME/bin/sqlplus -S ${CONNECT_STRING} << EOD > /u01/app/monitoring/nc_nrpe/bin/mso/db_status_$DB$current_date

set feedback off
set heading off
set linesize 120
$p1
$p2
$p3
$p4
$p5

exit;

EOD`

else

query=`$ORACLE_HOME/bin/sqlplus -S ${CONNECT_STRING} << EOD

set feedback off
set heading off
set linesize 120
select DECODE(rownum, 1, '', ' UNION ALL ') || 'SELECT ''' || table_name || ''' AS TABLE_NAME, COUNT(*) ' || ' FROM ' || table_name as query_string from all_tables where table_name like '${DB}';
exit;

EOD`
query="$query;"

DB=`echo $DB |sed 's/%/-/g'`
table=`$ORACLE_HOME/bin/sqlplus -S ${CONNECT_STRING} << EOD > /u01/app/monitoring/nc_nrpe/bin/mso/db_status_$DB$current_date

set feedback off
set heading off
set linesize 120
$query
exit;

EOD`

fi

sed -i '/^$/d' /u01/app/monitoring/nc_nrpe/bin/mso/db_status_$DB$current_date

declare -A value1
declare -A value2

cat /u01/app/monitoring/nc_nrpe/bin/mso/db_status_$DB$current_date|sed 's/ //g' > /tmp/key1

FILE=/u01/app/monitoring/nc_nrpe/bin/mso/db_status_$DB$yesterday_date
if [ -f "$FILE" ]; then
cat /u01/app/monitoring/nc_nrpe/bin/mso/db_status_IDB_$DB$yesterday_date|sed 's/ //g' > /tmp/key2
while IFS="     " read -p "index value" index value
do
        #echo "inserting $value at $index"
        value2[$index]="$value"
done < key2
rm /tmp/key2
else
    echo "Yesterday's Output file does not exist."
fi
while IFS="     " read -p "index value" index value
do
        #echo "inserting $value at $index"
        value1[$index]="$value"
done < key1
rm /tmp/key1
flag=0
for i in ${!value1[*]}
do
        for j in ${!value2[*]}
        do
          if [[ "$i" = "$j" ]];then
              FP=$((${value2[$i]}*5/100))
              DIFF=$((${value1[$i]}-${value2[$i]}))
              if [ "$DIFF" -gt "$FP" ];then
                  echo "5% = $FP";
                  echo "diff = $DIFF";
                  flag+=1;
              fi
          fi
        done
done
: '
if [ "$flag" -eq 0 ]
then
        echo "All values are same as yesterday"s output file."
fi  '

FILE1=/u01/app/monitoring/nc_nrpe/bin/mso/db_status_$DB$yesterday_date
FILE2=/u01/app/monitoring/nc_nrpe/bin/mso/db_status_$DB$current_date
if [ -f "$FILE1" && -f "$FILE2" && "$flag" -eq 0 ]
then
    echo "All values are same as yesterday's output file."
fi

exit $ICINGA_STATUS
