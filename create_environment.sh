#!/bin/bash
# create_environment.sh

echo "What is the name of the student?: "
read name

# Create main directory
mkdir submission_reminder_"$name"
cd submission_reminder_"$name" || exit

# Create subdirectories
mkdir -p app modules assets config

# Create startup file
touch startup.sh

# Create config file
cat <<EOF > config/config.env
# This is the config file
ASSIGNMENT="Shell Navigation"
DAYS_REMAINING=2
EOF

# Create functions.sh file
cat <<'EOF' > modules/functions.sh
#!/bin/bash
# Function to read submissions file and output students who have not submitted

function check_submissions {
    local submissions_file=$1
    echo "Checking submissions in $submissions_file"

    # Skip the header and iterate through the lines
    while IFS=, read -r student assignment status; do
        # Remove leading and trailing whitespace
        student=$(echo "$student" | xargs)
        assignment=$(echo "$assignment" | xargs)
        status=$(echo "$status" | xargs)

        # Check if assignment matches and status is 'not submitted'
        if [[ "$assignment" == "$ASSIGNMENT" && "$status" == "not submitted" ]]; then
            echo "Reminder: $student has not submitted the $ASSIGNMENT assignment!"
        fi
    done < <(tail -n +2 "$submissions_file") # Skip the header
}
EOF

# Create reminder.sh file
cat <<'EOF' > app/reminder.sh
#!/bin/bash
# Source environment variables and helper functions
source ./config/config.env
source ./modules/functions.sh

# Path to the submissions file
submissions_file="./assets/submissions.txt"

# Print remaining time and run the reminder function
echo "Assignment: $ASSIGNMENT"
echo "Days remaining to submit: $DAYS_REMAINING days"
echo "--------------------------------------------"

check_submissions "$submissions_file"
EOF

# Make scripts executable
chmod +x app/reminder.sh modules/functions.sh startup.sh

echo "✅ Environment setup complete for student: $name"

