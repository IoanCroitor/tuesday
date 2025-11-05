
#!/bin/bash

TARGET_DATE="$1"
CALENDAR_DIR="${2:-./calendars/active}"

if [ ! -d "$CALENDAR_DIR" ]; then
  echo "Error: Calendar directory not found at '$CALENDAR_DIR'" >&2
  exit 1
fi

# --- FIX 1: Normalize the user's input date to a standard YYYY-MM-DD format ---
NORMALIZED_TARGET_DATE=$(date -d "$TARGET_DATE" +%F) # %F is a shorthand for %Y-%m-%d

# These variables are still needed for the Recurrent event logic
TARGET_EPOCH=$(date -d "$TARGET_DATE 12:00:00" +%s)
TARGET_DOW=$(date -d "$TARGET_DATE" +%A)
TARGET_WEEK_NUM=$(date -d "$TARGET_DATE" +%V)
TARGET_DAY_OF_MONTH=$(date -d "$TARGET_DATE" +%d)

# (The declaration of arrays remains the same)
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

while IFS=, read -r Recurrence StartDate EndDate DayOfWeek Group Frequency StartTime EndTime Event Location Color
do
    Group="${Group#\"}"; Group="${Group%\"}"
    Event="${Event#\"}"; Event="${Event%\"}"

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
    find "$CALENDAR_DIR" -type f -name "*.csv" -exec cat {} + | while IFS=, read -r Recurrence StartDate EndDate DayOfWeek Group Frequency StartTime EndTime Event Location Color
    do
      if [ -z "$StartDate" ] || [[ "$StartDate" =~ [Ss]tart[Dd]ate ]]; then
        continue
      fi

      # --- FIX 2: Apply the robust date comparison to Single events ---
      if [ "$Recurrence" != "Recurrent" ]; then
        # Normalize the event's date from the file to YYYY-MM-DD
        EVENT_DATE_NORMALIZED=$(date -d "$StartDate" +%F)
        
        # Now compare the two normalized dates
        if [ "$EVENT_DATE_NORMALIZED" == "$NORMALIZED_TARGET_DATE" ]; then
          echo "$Recurrence,$StartDate,$EndDate,$DayOfWeek,$Group,$Frequency,$StartTime,$EndTime,$Event,$Location,$Color"
        fi
        continue # Move to the next line in the file
      fi

      # The rest of the logic for Recurrent events remains unchanged
      RULE_START_EPOCH=$(date -d "$StartDate 00:00:00" +%s)
      RULE_END_EPOCH=$(date -d "$EndDate 23:59:59" +%s)
      if [ "$TARGET_EPOCH" -lt "$RULE_START_EPOCH" ] || [ "$TARGET_EPOCH" -gt "$RULE_END_EPOCH" ]; then
        continue
      fi

      if [ "$Frequency" == "Monthly" ]; then
        RULE_START_DAY_OF_MONTH=$(date -d "$StartDate" +%d)
        if [ "$TARGET_DAY_OF_MONTH" == "$RULE_START_DAY_OF_MONTH" ]; then
          echo "$Recurrence,$StartDate,$EndDate,$DayOfWeek,$Group,$Frequency,$StartTime,$EndTime,$Event,$Location,$Color"
        fi
        continue
      fi

      if [ "$TARGET_DOW" != "$DayOfWeek" ]; then
        continue
      fi
        
    RULE_START_WEEK_NUM=$(date -d "$StartDate" +%V)
    WEEK_DIFF=$((TARGET_WEEK_NUM - RULE_START_WEEK_NUM))

    case "$Frequency" in
      "Weekly")
          ;; 
      "Odd")
          if [ $((WEEK_DIFF % 2)) -ne 0 ]; then
              :
          else
              continue
          fi
          ;;
      "Even")
          if [ $((WEEK_DIFF % 2)) -eq 0 ]; then
              :
          else
              continue
          fi
          ;;
      *)
          continue
          ;;
    esac

    echo "$Recurrence,$StartDate,$EndDate,$DayOfWeek,$Group,$Frequency,$StartTime,$EndTime,$Event,$Location,$Color"

    done
  } | sort -t ',' -k 7,7 -k 8,8
)