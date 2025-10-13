#!/bin/bash
echo "What is the name of the student?: "
read name

mkdir submission_reminder_"$name"
cd submission_reminder_"$name" || exit

mkdir -p app modules assets config

touch startup.sh

cat <<EOF > config/config.env
ASSIGNMENT="Shell Navigation"
DAYS_REMAINING=2
EOF

cat <<'EOF' > modules/functions.sh
#!/bin/bash

function check_submissions {
    local submissions_file=$1
    echo "Checking submissions in $submissions_file"

    while IFS=, read -r student assignment status; do
        student=$(echo "$student" | xargs)
        assignment=$(echo "$assignment" | xargs)
        status=$(echo "$status" | xargs)

        if [[ "$assignment" == "$ASSIGNMENT" && "$status" == "not submitted" ]]; then
            echo "Reminder: $student has not submitted the $ASSIGNMENT assignment!"
        fi
    done < <(tail -n +2 "$submissions_file") # Skip the header
}
EOF

cat <<'EOF' > app/reminder.sh
#!/bin/bash
source ./config/config.env
source ./modules/functions.sh

submissions_file="./assets/submissions.txt"

echo "Assignment: $ASSIGNMENT"
echo "Days remaining to submit: $DAYS_REMAINING days"
echo "--------------------------------------------"

check_submissions "$submissions_file"
EOF

chmod +x app/reminder.sh modules/functions.sh startup.sh

echo "✅ Environment setup complete for student: $name"

