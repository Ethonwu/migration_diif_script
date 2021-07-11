#!/bin/bash

find ${DESTINATION_PATH} -printf "depth="%d/"sym perm="%M/"perm="%m/"size="%s/"user="%u/"group="%g/"name="%p/"type="%Y\\n > /tmp/${DEST_LOG_NAME}
