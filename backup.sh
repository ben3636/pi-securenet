#!/bin/bash

mkdir -p WEB-BK

du -a . | awk ' { print $2 } ' | grep -e ".php" -e ".sh" | while read line
do
	cp $line WEB-BK/
done

zip -r BACKUP.zip WEB-BK/
