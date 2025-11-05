# Calendar - Tuesday
A simple cli for displaying a calendar from a csv file.

```text
   _______                          _               
  '   /    ,   .   ___    ____   ___/   ___  ,    . 
      |    |   | .'   `  (      /   |  /   ` |    ` 
      |    |   | |----'  `--.  ,'   | |    | |    | 
      /    `._/| `.___, \___.' `___,' `.__/|  `---|.
                                    `         \___/ 
```

## Arguments 

Display the minimal calendar
```bash
./main -m 
```
Display the calendar for a specific date
```bash
./main YYYY-MM-DD
```
Display the minimal calendar for a specific date
```bash
./main -m YYYY-MM-DD
```


The calendar's data source is located in the `./calendars/` directory.

- `./calendars/active/` keeps the active calendars for showing
- `./calendars/inactive` keeps the inactove calendars  


```csv
Type,StartDate,EndDate,Day,Group,RecurrenceRule,StartTime,EndTime,Event,Location,Color
```

| Field Name    | Type / Description |
|----------------|--------------------|
| Recurrence     | `"Recurrent"` \| `"Single"` — specifies whether the event repeats (`Recurrent`) or occurs once (`Single`) |
| StartDate      | `string` — `YYYY-MM-DD`, the first valid date for this rule (for recurrent events) or the event date (for single ones) |
| EndDate        | `string` — `YYYY-MM-DD`, the last valid date for this rule (for recurrent events); ignored for single ones |
| DayOfWeek      | `"Monday"` \| `"Tuesday"` \| … \| `"Sunday"` — which weekday the event occurs on (only checked for recurrent events) |
| Group          | `string` — logical grouping (e.g. `"1211EA sgr 1"`), usually the class or subgroup name |
| Frequency      | `"Weekly"` \| `"Even"` \| `"Odd"` \| `"Monthly"` — recurrence frequency rule determining which weeks or days the event repeats on |
| StartTime      | `string` — `HH:MM` (24h format), event start time |
| EndTime        | `string` — `HH:MM` (24h format), event end time |
| Event          | `string` — event title or course name, e.g. `"EE 1 (C)"`, `"OS 1 (C)"` |
| Location       | `string` — classroom or location code, e.g. `"AN017"`, `"AN024"` |
| Color          | `string` — color tag for UI visualization (e.g. `"red"`, `"blue"`, `"purple"`) |



## Made with love by:
- 12111EA 



Type,StartDate,EndDate,Day,Group,RecurrenceRule,StartTime,EndTime,Event,Location,Color
Recurrent,2025-10-07,2025-12-19,Tuesday,"1211EA sgr 1",EvenWeeks,10:00,12:00,"S: EE 1",AN024,Blue
Recurrent,2025-10-07,2025-12-19,Tuesday,"1211EA sgr 1",Weekly,14:00,16:00,"Communication I (S) Patrut B",BN029,Green
Recurrent,2025-10-07,2025-12-19,Tuesday,"1211EA sgr 1",Weekly,16:00,18:00,"EE 1 (C)",AN017,Red
Recurrent,2025-10-07,2025-12-19,Tuesday,"1211EA sgr 1",Weekly,19:00,21:00,"OS 1 (C)",AN017,Purple



Type,StartDate,EndDate,Day,Group,RecurrenceRule,StartTime,EndTime,Event,Location,Color
Recurrent,2025-10-06,2025-12-15,Monday,"1211EA sgr 1",Weekly,08:00,10:00,"CAG (L)",BN308,cyan
Recurrent,2025-10-06,2025-12-15,Monday,"1211EA sgr 1",Weekly,10:00,12:00,"Chemistry (S)",(unspecified),orange
Recurrent,2025-10-06,2025-12-15,Monday,"1211EA sgr 1",Weekly,12:00,14:00,"Physical Education I (L)",Sports Hall,green





