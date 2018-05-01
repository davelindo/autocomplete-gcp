#!/bin/sh
set -x
set -e
#add host string to targets
awk -v TARGET_HOST="$TARGET_HOST" '{print TARGET_HOST $0}' targets > tmptargets

#Shuffle the list for randomness
shuf -o /app/targets /app/tmptargets
rm /app/tmptargets

RAMP_DURATION=$(echo "${DURATION} / 10" | bc)

#run stress test in 10 increments (allow some cache warming)
for i in $(seq 10) ; do
  RAMP_RATE=$(echo "(${RATE} * ${i}) / 10" | bc)
  echo "Vegeta attack at ${RAMP_RATE} requests/s for ${RAMP_DURATION}s"
  vegeta attack -duration=${RAMP_DURATION}s -targets=/app/targets -rate=${RAMP_RATE} -timeout=${TIMEOUT} | tee results.bin | vegeta report
  
  #Shuffle again to slowly increase cache hit rate over time
  shuf -o /app/tmptargets /app/targets
  mv /app/tmptargets /app/targets
done