#!/bin/bash

. ./.gh-api-examples.conf

max_attempts=5
attempt=0
status_code=404

sleep_for=3

#filename_to_download="requirements.txt"
filename_to_download="to2c.txt"
output_filename="tmp/to2c.txt"

while [ $status_code -eq 404 ] && [ $attempt -lt $max_attempts ]; do
  ((attempt++))
  echo "Attempt $attempt of $max_attempts"

  # Make the HTTP request and capture the status code
  status_code=$(curl -o /dev/null -s -w "%{http_code}\n" -H 'Accept: application/vnd.github.v3.raw' -H "Authorization: Bearer ${GITHUB_TOKEN}" "${GITHUB_API_BASE_URL}/repos/${org}/${repo}/contents/${filename_to_download}" -o ${output_filename})
  if [ $status_code -eq 200 ]; then
    echo "Success: Received 200 OK"
  else
    echo "Received status code $status_code, retrying..."
    sleep ${sleep_for}
  fi
done

if [ $status_code -ne 200 ]; then
  echo "Failed to receive 200 OK after $max_attempts attempts"
fi
