

Print(TimeToStr(TimeCurrent(), TIME_DATE) + " " + TimeToStr(TimeCurrent(), TIME_MINUTES));
Print(TimeToStr(time_entry, TIME_DATE) + " " + TimeToStr(time_entry, TIME_MINUTES));


datetime time_entry = StrToTime(TimeToStr(Time[0], TIME_DATE) + " " + Entry_Time);


StrToTime() use system date, not broker date by default.