#!/usr/bin/env bash

# Adds hosts entry for given hostname.
# Arguments:
#   hostname : string

# Local machine
ip_address="127.0.0.1"
hostname=${1}

# Find existing instances in the host file and save the line numbers.
matches_in_hosts="$(grep -n hostname /etc/hosts | cut -f1 -d:)"
host_entry="${ip_address} ${hostname}"

if [ ! -z "$matches_in_hosts" ]
then
    echo "Updating existing hosts entry for hostname '${hostname}'."
    # Iterate over the line numbers on which matches were found.
    while read -r line_number; do
        # Replace the text of each line with the desired host entry.
        sudo sed -i '' "${line_number}s/.*/${host_entry} /" /etc/hosts
    done <<< "$matches_in_hosts"
else
    echo "Adding new hosts entry '${ip_address} ${hostname}'."
    echo "$host_entry" | sudo tee -a /etc/hosts > /dev/null
fi