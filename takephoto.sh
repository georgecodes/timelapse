#!/bin/sh

export DIR="/tmp/photos"
export TIMESTAMP=`date +%Y-%m-%d-%H.%M.%S`
export FILENAME="${DIR}/${TIMESTAMP}.jpg"

mkdir -p $DIR
echo "Attempting to take photograph and save in ${FILENAME}"

OUTPUT=$(gphoto2 --capture-image-and-download --filename ${FILENAME})

echo $OUTPUT

if [ $? -ne 0 ]; then 
  echo "I tried to take a photo ${TIMESTAMP} but it failed for some reason\n\n${OUTPUT}" | mail -s "Photo failed" george@georgemcintosh.com
  exit -1
fi

scp ${FILENAME} root@emohawk.local:/volume1/westquay/images/raw/

if [ $? -eq 0 ]; then
  echo "I took a photo ${TIMESTAMP} and uploaded it" | mail -s "Photo uploaded" george@georgemcintosh.com
  rm ${FILENAME}
else
  echo "I took a photo ${TIMESTAMP} but it didn't upload" | mail -s "Photo taken but not uploaded" george@georgemcintosh.com
  exit -2
fi
