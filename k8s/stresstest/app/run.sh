#!/bin/sh
#add host string to targets
awk -v TARGET_HOST="$TARGET_HOST" '{print TARGET_HOST $0}' targets > tmptargets
mv /app/tmptargets /app/targets

#run stress test 
vegeta attack -duration=${DURATION} -targets=/app/targets -rate=${RATE} -timeout=${TIMEOUT} | tee results.bin | vegeta report
