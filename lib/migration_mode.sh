#!/usr/bin/env bash

set -Eeuio pipefail
TIMESATMP=$(date +"%Y-%m-%d %H:%M:%S")

sync_data() {
    msg "${TIMESATMP} - ${BLUE}INFO${NOFORMAT} : This is ${MODE} mode"
    msg "${TIMESATMP} - ${BLUE}INFO${NOFORMAT} : Source Path is ${SOURCE}"
    msg "${TIMESATMP} - ${BLUE}INFO${NOFORMAT} : Destination Path is ${DESTINATION}"
    msg "${TIMESATMP} - ${BLUE}INFO${NOFORMAT} : Now Starting rsync ${SOURCE} to ${DESTINATION}"

    # Use StrictHostKeyChecking and UserKnownHostsFile to avoid ssh know host problem
    rsync -avzh --delete -e "ssh -q -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null" ${SOURCE} ${DESTINATION}
    
    msg "${TIMESATMP} - ${BLUE}INFO${NOFORMAT} : Finish rsync ${SOURCE} to ${DESTINATION}"
}

diff_data() {
    DEST_LOG_NAME="$(date +'%Y-%m-%d')_dest.log"
    SRC_LOG_NAME="$(date +'%Y-%m-%d')_source.log"
    ERROR_LOG_NAME="$(date +'%Y-%m-%d')_diff_error.log"

    msg "${TIMESATMP} - ${BLUE}INFO${NOFORMAT} : This is ${MODE} mode"
    msg "${TIMESATMP} - ${BLUE}INFO${NOFORMAT} : Source Path is ${SOURCE}"
    msg "${TIMESATMP} - ${BLUE}INFO${NOFORMAT} : Destination Path is ${DESTINATION}"
    msg "${TIMESATMP} - ${BLUE}INFO${NOFORMAT} : Now Starting compare with ${SOURCE} and ${DESTINATION}"

    DESTINATION_INFO=$(echo ${DESTINATION} | awk -F ":" {'print $1'})  
    DESTINATION_PATH=$(echo ${DESTINATION} | awk -F ":" {'print $2'})
    # Send gen folder tree script to destination 
    scp -q -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null ./lib/output_folder_tree.sh ${DESTINATION_INFO}:/tmp/
    ssh -q -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null ${DESTINATION_INFO} "DESTINATION_PATH=${DESTINATION_PATH} DEST_LOG_NAME=${DEST_LOG_NAME} sh /tmp/output_folder_tree.sh"
    scp -q -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null ${DESTINATION_INFO}:/tmp/${DEST_LOG_NAME} .
    find ${SOURCE} -printf "depth="%d/"sym perm="%M/"perm="%m/"size="%s/"user="%u/"group="%g/"name="%p/"type="%Y\\n > ${SRC_LOG_NAME}
    sort -V ${SRC_LOG_NAME} > "sort_${SRC_LOG_NAME}"
    sort -V ${DEST_LOG_NAME} > "sort_${DEST_LOG_NAME}"
    if diff -q sort_${SRC_LOG_NAME} sort_${DEST_LOG_NAME} > /dev/null
    	then
	    msg "${TIMESATMP} - ${GREEN}OK${NOFORMAT} : ${SOURCE} and ${DESTINATION} folder tree is same"
    else
	msg "${TIMESATMP} - ${RED}ERROR${NOFORMAT} : ${SOURCE} and ${DESTINATION} folder tree is not same please check error log"
        diff -y ${SRC_LOG_NAME} ${DEST_LOG_NAME} > ${ERROR_LOG_NAME}
    fi
      
    msg "${TIMESATMP} - ${BLUE}INFO${NOFORMAT} : Finish compare with ${SOURCE} and ${DESTINATION}"
}

