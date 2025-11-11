#!/bin/sh

curl -vu guest:guest -X PUT http://localhost:15672/api/vhosts/%2F
curl -vu guest:guest -X PUT http://localhost:15672/api/vhosts/myvhost
curl -vu guest:guest -X PUT http://localhost:15672/api/vhosts/othervhost

# Create a user with management access (so it can use the HTTP API)
curl -vu guest:guest -X PUT http://localhost:15672/api/users/myuser \
  -H "Content-Type: application/json" \
  -d '{"password":"mypass","tags":"management"}'

sleep 5

# Grant permissions only on myvhost
curl -vu guest:guest -X PUT http://localhost:15672/api/permissions/myvhost/myuser \
  -H "Content-Type: application/json" \
  -d '{"configure":".*","write":".*","read":".*"}'

sleep 5

# Create a test queue
curl -vu myuser:mypass -X PUT http://localhost:15672/api/queues/myvhost/testqueue \
  -H "Content-Type: application/json" \
  -d '{}'

sleep 5

# Trigger the issue / improvement
curl -vu myuser:mypass http://localhost:15672/api/queues/myvhost
