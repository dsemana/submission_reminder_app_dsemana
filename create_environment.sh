#!/bin/bash

#get the name of the student and store it in a variable
echo "What is the name of the student?: "
read name

#create the folder of the student
mkdir submission_reminder_"$name"
cd submission_reminder_"$name" || exit

#create folders within
mkdir -p app modules assets config

touch startup.sh

touch config/config.env
cd config
echo -e "
# This is the config file
ASSIGNMENT="Shell Navigation"
DAYS_REMAINING=2
" >> config.env
cd ..

touch modules/functions.sh
cd modules

echo -e "
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
    done < <(tail -n +2 "$submissions_file") 

    " >> functions.sh
cd ..

touch app/reminder.sh
cd app

echo -e "
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

check_submissions $submissions_file
" >> reminder.sh

cd ..
touch assets/submissions.txt
cd assets
echo -e "
student, assignment, submission status
Chinemerem, Shell Navigation, not submitted
Chiagoziem, Git, submitted
Divine, Shell Navigation, not submitted
Anissa, Shell Basics, submitted
Alain, Python, not submitted
" >> submissions.txt
cd ..

chmod +x app/reminder.sh modules/functions.sh startup.sh

echo "✅ Environment setup complete for student: $name"

cd submission_reminder_$name
