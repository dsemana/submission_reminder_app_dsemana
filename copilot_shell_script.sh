#!/bin/bash

# Ask for new assignment name
read -p "Enter the new assignment name: " NEW_ASSIGNMENT

# Update ASSIGNMENT value in config/config.env
sed -i "s/^ASSIGNMENT=.*/ASSIGNMENT=\"${NEW_ASSIGNMENT}\"/" ./config/config.env

echo "Assignment updated to: ${NEW_ASSIGNMENT}"
echo "Re-running the reminder application..."
sleep 1
bash startup.sh

