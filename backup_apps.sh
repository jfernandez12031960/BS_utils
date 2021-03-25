#!/bin/bash
# Script to extract Netscaler database

if [ "$#" -lt 2 ]
then
	echo "Usage:$0 application days2keep [subdir_bk]\nRecordar posar la cariable d'entorn $APPSERVER_HOME" 1>&2
	exit 1
fi

app_db=$1
days2keep=$2

if [ "$#" -eq 3 ]
then
	subdir_bk=$3
else
	subdir_bk="backup"
fi

absolute_path=`strncmp.e "$subdir_bk" "/" 1`

if [ "$absolute_path" -eq 0 ]
then
	backup_path=$subdir_bk
else
	backup_path=$APPSERVER_HOME/$subdir_bk
fi

now=`date.e 0 | sed 's/:/-/'`
application=$(echo $app_db | sed 's/:.*$//g')

# Backup Appserver Tables
# ------------------------
output_file=$APPSERVER_HOME/data/insert_${application}_appserver.sql.gz
bk_file=${backup_path}/insert_${application}_appserver-${now}.sql.gz

export_application $app_db '' '' '' $application n y '' '' mysql sql_statements > /dev/null

mv ${output_file} $bk_file

# Backup Application Tables
# -------------------------
output_file=$APPSERVER_HOME/data/insert_${application}.sql.gz
bk_file=${backup_path}/insert_${application}-${now}.sql.gz

export_application $app_db '' '' '' $application n n '' '' mysql sql_statements > /dev/null

mv ${output_file} $bk_file

# Execute create application appserver
# -------------------------------------
output_file=$APPSERVER_HOME/data/create_${application}_appserver.sh
bk_file_appserver=${backup_path}/create_${application}_appserver-${now}.sh

create_application $app_db y '' '' $application y y '' >/dev/null

cat ${output_file} | sed 's/^exit 0//' > $bk_file_appserver

# Execute create application
# --------------------------
output_file=$APPSERVER_HOME/data/create_${application}.sh
bk_file=${backup_path}/create_${application}-${now}.sh

create_application $app_db y '' '' $application n y '' >/dev/null

cat ${output_file} | sed 's/^exit 0//' > $bk_file

# Clean out backup files
# ----------------------
find ${backup_path}/ -type f -mtime +$days2keep -exec rm {} \;

exit 0