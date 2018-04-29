#!/bin/sh
#add host string to targets
awk -v TARGET_HOST="$TARGET_HOST" '{print TARGET_HOST $0}' targets > tmptargets

#Shuffle the list for randomness
shuf -o /app/targets /app/tmptargets

#run stress test 
vegeta attack -duration=${DURATION} -targets=/app/targets -rate=${RATE} -timeout=${TIMEOUT} | tee results.bin | vegeta report
