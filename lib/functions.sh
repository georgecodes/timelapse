#!/bin/bash

function log {
	local MESSAGE="$(date) - $1"
	echo $MESSAGE
}

function send_mail {
	local SUBJECT=$1
	local MESSAGE=$2
	echo $MESSAGE | mail -s $SUBJECT george@georgemcintosh.com
}

function take_photo {
	local FILENAME=$1
	log "Taking photo and saving as ${FILENAME}"
	/usr/local/bin/gphoto2 --capture-image-and-download --filename ${FILENAME}
	if [ $? -ne 0 ]; then 
  		FAIL_MESSAGE="I tried to take a photo ${FILENAME} but it failed for some reason"
  		log $FAIL_MESSAGE
  		send_mail "Photo failed" $FAIL_MESSAGE
  		exit -1
	fi
}

function upload_photo {
	local FILENAME=$1
	local DESTINATION=$2
	scp ${FILENAME} root@emohawk.local:$DESTINATION
	if [ $? -ne 0 ]; then
  		MESSAGE="I took a photo ${TIMESTAMP} but it didn't upload" 
  		log $MESSAGE
  		send_mail "Photo taken but not uploaded" $MESSAGE
  		exit -2
	fi
}

function compress_photo {
	local SOURCE=$1
	local DESTINATION=$2
	/usr/bin/convert $SOURCE -resize 1024x960 $DESTINATION
	if [ $? -ne 0 ]; then 
  		FAIL_MESSAGE="I tried to resize a photo ${SOURCE} but it failed for some reason"
 		log $FAIL_MESSAGE
  		send_mail "Resize failed" $FAIL_MESSAGE
  		exit -3
	fi
}

function send_photo {
	local PHOTO=$1
	/usr/bin/mpack -s "New photo uploaded" $PHOTO george@georgemcintosh.com
}