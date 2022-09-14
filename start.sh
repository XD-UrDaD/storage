#!/bin/bash
echo off
echo "
 __   ___ _          _____                      _ _         
 \ \ / (_) |        / ____|                    (_) |        
  \ V / _| |_ ___  | (___   ___  ___ _   _ _ __ _| |_ _   _ 
   > < | | __/ _ \  \___ \ / _ \/ __| | | | '__| | __| | | |
  / . \| | ||  __/  ____) |  __/ (__| |_| | |  | | |_| |_| |
 /_/ \_\_|\__\___| |_____/ \___|\___|\__,_|_|  |_|\__|\__, |
                                                       __/ |
                                                      |___/ 
"

echo "Cheching Root"
echo "This Script is for people who doesn't know about linux"
echo -n "Do you want to update Student Data (Faces) default (No) [Enter Either Y/Yes] : "
read $y
echo "Taking Backup"
cd /var/JARVIS/cam/openvc/students/
apt install zip -y
zip backup.zip **
mkdir -p /var/JARVIS/backup/
mv backup.zip /var/JARVIS/backup/
echo "Back Up Completed"
if [[ $y == "Yes" || [$y == "Y"]];
then 
echo "Enter The Path Enter Full Path [Do Pwd for the path and Don't Include /.. in the starting || File must in .zip format]"
read $path
echo "Enter File Name (Include .zip also)"
read $file
cd /var/JARVIS/cam/openvc/students/
rm -rf **
cp /$path/$file /var/JARVIS/cam/opencv/students/
unzip $file
fi
echo "Do want to Push Local DB to MySQL default (No) [Enter Either Y/Yes]"
read $w
if [[ $w == "Yes" || [$w== "Y"]];
then
echo"Is MySQL Database Setted Up? [Enter Either Y/Yes/N/No] (Make Sure MySQL is Properly Installed"
read $m
if [[ $m == "Yes" || [$m == "Y"]];
then
$db_user = "admin"
$db_password = "changeme"
$db_name = "Attendance"
echo "* Performing MySQL queries.."
echo "* Creating MySQL user.."
mysql -u root -p -e "CREATE USER '${db_user}'@'%' IDENTIFIED BY '${db_password}';"
echo "* Creating database.."
mysql -u root -e "CREATE DATABASE ${db_name};"
echo "* Granting privileges.."
mysql -u root -e "GRANT ALL PRIVILEGES ON ${db_name}.* TO '${db_user}'@'%' WITH GRANT OPTION;"
echo "* Flushing privileges.."
mysql -u root -e "FLUSH PRIVILEGES;"
echo "* MySQL database created & configured!"
cd /var/JARVIS/cam/opencv/
echo "Pushing Local Data to MySQL"
mysql -u root -e "use ${db_name};"
mysql -u root -e "CREATE TABLE attendance 
name VARCHAR(100),
Time VARCHAR(100),
Date VARCHAR(100),
);"
mysql -u root -e "LOAD DATA INFILE 'cd /var/JARVIS/cam/opencv/Attendance.csv'
INTO TABLE employee_details
FIELDS TERMINATED BY ','
IGNORE 1 ROWS;"
fi
echo "Do you want to reset attendance.csv default (No) [Enter Either Y/Yes]"
read $e
if [[ $e == "Yes" || [$e == "Y"]];
then
cd /var/JARVIS/cam/opencv/
rm Attendance.csv
wget https://raw.githubusercontent.com/XD-UrDaD/storage/main/Attendance.csv
fi
cd /var/JARVIS/cam/opencv/
python3 attendance.py
