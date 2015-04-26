#!/bin/bash

export DIR="/tmp"
export LOG_FILE="/var/log/takephoto/takephoto.log"
export TIMESTAMP=`date +%Y-%m-%d-%H.%M.%S`
export FILENAME="${DIR}/${TIMESTAMP}.jpg"

function log {
	echo $1
	echo $1 >> $LOG_FILE
}

log "Attempting to take photograph and save in ${FILENAME}"

OUTPUT=$(gphoto2 --capture-image-and-download --filename ${FILENAME})

log $OUTPUT

if [ $? -ne 0 ]; then 
  FAIL_MESSAGE="I tried to take a photo ${TIMESTAMP} but it failed for some reason\n\n${OUTPUT}"
  log $FAIL_MESSAGE
  echo $FAIL_MESSAGE | mail -s "Photo failed" george@georgemcintosh.com
  exit -1
fi

OUTPUT=$(scp ${FILENAME} root@emohawk.local:/volume1/westquay/images/raw/)

log $OUTPUT

if [ $? -eq 0 ]; then
  MESSAGE="I took a photo ${TIMESTAMP} and uploaded it"
  log $MESSAGE
  echo $MESSAGE | mail -s "Photo uploaded" george@georgemcintosh.com
  rm ${FILENAME}
else
  MESSAGE="I took a photo ${TIMESTAMP} but it didn't upload\n\n${OUTPUT}" 
  log $MESSAGE
  echo $MESSAGE | mail -s "Photo taken but not uploaded" george@georgemcintosh.com
  exit -2
fi
