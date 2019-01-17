#!/bin/bash

gradle clean
gradle build -x test
scp build/libs/coinmax-0.0.1-SNAPSHOT.jar web@166.62.85.61:~/tmp/coinmax-main.jar

ssh web@166.62.85.61 <<eeooff
sleep 3

echo '##################is going to kill the process############################'
sleep 2
ps -ef|grep '.*'"coinmax-main"'.*$'|grep -v grep|awk '{print \$2}'|xargs kill -9
sleep 2


echo '#################update the jar###########################################'

now=`date +%Y%m%d_%H%M%S`
mv ~/jar/coinmax-main.jar ~/bak/coinmax-main/coinmax-main-$now.jar
mv ~/tmp/coinmax-main.jar ~/jar/coinmax-main.jar

echo '#########its going to publish ################################'

nohup java -jar ~/jar/coinmax-main.jar --spring.profiles.active=prod >~/stdout/coinmax.log 2>&1 &

exit
eeooff

