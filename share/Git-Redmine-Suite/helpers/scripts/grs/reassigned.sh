function reassigned_task_to {
	PROJECT=$1

	redmine-get-project-users-id --project="$PROJECT"
	echo ""

	PREVIOUS_ASSIGNED_TO_ID=$(git config redmine.previous.finish.task)

	declare -a PARAMS=(--question "Which one do you want to assigned the task to ?" --answer_mode "id")
	if [ -n "$PREVIOUS_ASSIGNED_TO_ID" ]; then
		PARAMS+=(--default_answer "$PREVIOUS_ASSIGNED_TO_ID")
	fi

	ASSIGNED_TO_ID=$(ask_question "${PARAMS[@]}")

	if ! redmine-check-project-users-id --project="$PROJECT" --assigned_to_id="$ASSIGNED_TO_ID"; then
		echo "This user is not a member of this project !"
		exit 1
	fi
}