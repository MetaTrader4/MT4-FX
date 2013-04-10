



entry_time_1 = StrToTime(Entry_Time1);


if(
   TimeCurrent() >= entry_time_1 && Time[0] <= entry_time_1
   && time_phase_1 < Time[0]
)
{
      time_phase_1 = Time[0];
      
}


Print(TimeToStr(text_arr[1], TIME_DATE) + " " + TimeToStr(text_arr[1], TIME_MINUTES));