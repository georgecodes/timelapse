#!/bin/bash

SCRIPT_DIR=`dirname $0`
export DIR="/tmp"
export LOG_FILE="/var/log/takephoto/takephoto.log"
export TIMESTAMP=`date +%Y-%m-%d-%H.%M.%S`
export FILENAME="${DIR}/${TIMESTAMP}.jpg"
export COMPRESSED_FILENAME="${DIR}/${TIMESTAMP}_compressed.jpg"
export RAW_DIR="/volume1/westquay/images/raw/"
export COMPRESSED_DIR="/volume1/westquay/images/compressed"

source "${SCRIPT_DIR}/lib/functions.sh"

take_photo $FILENAME
upload_photo $FILENAME $RAW_DIR
compress_photo $FILENAME $COMPRESSED_FILENAME
upload_photo $COMPRESSED_FILENAME $COMPRESSED_DIR
send_photo $COMPRESSED_FILENAME
