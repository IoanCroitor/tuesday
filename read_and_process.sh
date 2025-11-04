#!/bin/bash



# --- 1. Input Validation ---
if [ -z "${1-}" ]; then
  echo "Usage: $0 YYYY-MM-DD"
  echo "Example: $0 2025-11-04"
  exit 1
fi

TARGET_DATE="$1"

# --- 2. Calculate Target Date Properties ---
TARGET_EPOCH=$(date -d "$TARGET_DATE 12:00:00" +%s)
TARGET_DOW=$(date -d "$TARGET_DATE" +%A)
TARGET_WEEK_NUM=$(date -d "$TARGET_DATE" +%V)
TARGET_WEEK_PARITY=$((TARGET_WEEK_NUM % 2))
TARGET_DAY_OF_MONTH=$(date -d "$TARGET_DATE" +%d)

# --- 3. Initialize Arrays for Event Data ---
declare -a Recurrences=()
declare -a StartDates=()
declare -a EndDates=()
declare -a DaysOfWeek=()
declare -a Groups=()
declare -a Frequencies=()
declare -a StartTimes=()
declare -a EndTimes=()
declare -a Events=()
declare -a Locations=()
declare -a Colors=()

# --- 4. Process Events and Populate Arrays ---
# The outer `while` loop reads sorted, matching event data.
# Using process substitution `< <(...)` ensures the arrays are populated in the current shell.
while IFS=, read -r Recurrence StartDate EndDate DayOfWeek Group Frequency StartTime EndTime Event Location Color
do
    # Remove leading/trailing quotes from fields that might have them
    Group="${Group#\"}"; Group="${Group%\"}"
    Event="${Event#\"}"; Event="${Event%\"}"

    # Add the cleaned data to the arrays
    Recurrences+=("$Recurrence")
    StartDates+=("$StartDate")
    EndDates+=("$EndDate")
    DaysOfWeek+=("$DayOfWeek")
    Groups+=("$Group")
    Frequencies+=("$Frequency")
    StartTimes+=("$StartTime")
    EndTimes+=("$EndTime")
    Events+=("$Event")
    Locations+=("$Location")
    Colors+=("$Color")

done < <(
  {
    cat -- *.csv | while IFS=, read -r Recurrence StartDate EndDate DayOfWeek Group Frequency StartTime EndTime Event Location Color
    do
    
      if [ -z "$StartDate" ] || [[ "$StartDate" =~ [Ss]tart[Dd]ate ]]; then
        continue
      fi

      # --- Rule: Handle "One-time" Events ---
      if [ "$Recurrence" != "Recurrent" ]; then
        if [ "$StartDate" == "$TARGET_DATE" ]; then
          echo "$Recurrence,$StartDate,$EndDate,$DayOfWeek,$Group,$Frequency,$StartTime,$EndTime,$Event,$Location,$Color"
        fi
        continue
      fi


      # --- Rule: Check if target date is within the event's active range ---
      RULE_START_EPOCH=$(date -d "$StartDate 00:00:00" +%s)
      RULE_END_EPOCH=$(date -d "$EndDate 23:59:59" +%s)
      if [ "$TARGET_EPOCH" -lt "$RULE_START_EPOCH" ] || [ "$TARGET_EPOCH" -gt "$RULE_END_EPOCH" ]; then
        continue
      fi

      # --- Rule: Check for "Monthly" frequency ---
      if [ "$Frequency" == "Monthly" ]; then
        RULE_START_DAY_OF_MONTH=$(date -d "$StartDate" +%d)
        if [ "$TARGET_DAY_OF_MONTH" == "$RULE_START_DAY_OF_MONTH" ]; then
          echo "$Recurrence,$StartDate,$EndDate,$DayOfWeek,$Group,$Frequency,$StartTime,$EndTime,$Event,$Location,$Color"
        fi
        continue
      fi

      # --- Rule: Check if the day of the week matches ---
      if [ "$TARGET_DOW" != "$DayOfWeek" ]; then
        continue
      fi

      # --- Rule: Handle weekly-based frequencies (Weekly, Odd, Even, Bi-weekly) ---
     case "$Frequency" in
        "Weekly")
            ;; 
        "Odd")
            if [ "$TARGET_WEEK_PARITY" -eq 0 ]; then continue; fi
            ;;
        "Even")
            if [ "$TARGET_WEEK_PARITY" -ne 0 ]; then continue; fi
            ;;
        *)
            # Skip unknown
            continue
            ;;
        esac


      echo "$Recurrence,$StartDate,$EndDate,$DayOfWeek,$Group,$Frequency,$StartTime,$EndTime,$Event,$Location,$Color"

    done
  } | sort -t ',' -k 7,7 -k 8,8 # Sort all matching events by start time, then end time
)

