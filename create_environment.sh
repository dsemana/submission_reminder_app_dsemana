#!/bin/bash

# Prompt user for their name
read -p "Enter your name: " USERNAME
MAIN_DIR="submission_reminder_${USERNAME}"

# Create directory structure
mkdir -p "$MAIN_DIR"/{assets,config,modules,app}

echo "📁 Creating submission reminder environment for $USERNAME..."

# 1. Create and populate submissions.txt
cat > "$MAIN_DIR/assets/submissions.txt" << 'EOF'
student, assignment, submission status
Chinemerem, Shell Navigation, not submitted
Chiagoziem, Git, submitted
Divine, Shell Navigation, not submitted
Anissa, Shell Basics, submitted
Liam, Shell Navigation, submitted
Aisha, Shell Navigation, not submitted
Noah, Shell Navigation, not submitted
Grace, Shell Basics, submitted
Emmanuel, Git, not submitted
Khadija, Shell Navigation, not submitted
EOF

# 2. Create config.env
cat > "$MAIN_DIR/config/config.env" << 'EOF'
# This is the config file
ASSIGNMENT="Shell Navigation"
DAYS_REMAINING=2
EOF

# 3. Create functions.sh
cat > "$MAIN_DIR/modules/functions.sh" << 'EOF'
#!/bin/bash
# Function to read submissions file and output students who have not submitted
function check_submissions {
    local submissions_file=$1
    echo "Checking submissions in $submissions_file"

    # Skip the header and iterate through the lines
    while IFS=, read -r student assignment status; do
        student=$(echo "$student" | xargs)
        assignment=$(echo "$assignment" | xargs)
        status=$(echo "$status" | xargs)

        if [[ "$assignment" == "$ASSIGNMENT" && "$status" == "not submitted" ]]; then
            echo "Reminder: $student has not submitted the $ASSIGNMENT assignment!"
        fi
    done < <(tail -n +2 "$submissions_file")
}
EOF

# 4. Create reminder.sh inside app/
cat > "$MAIN_DIR/app/reminder.sh" << 'EOF'
#!/bin/bash
source ./config/config.env
source ./modules/functions.sh
submissions_file="./assets/submissions.txt"

echo "Assignment: $ASSIGNMENT"
echo "Days remaining to submit: $DAYS_REMAINING days"
echo "--------------------------------------------"

check_submissions $submissions_file
EOF

# 5. Create startup.sh in root of app
cat > "$MAIN_DIR/startup.sh" << 'EOF'
#!/bin/bash
echo "Starting Submission Reminder App..."
bash ./app/reminder.sh
EOF

# 6. Make all .sh files executable
find "$MAIN_DIR" -type f -name "*.sh" -exec chmod +x {} \;

echo "✅ Environment created for $USERNAME"
