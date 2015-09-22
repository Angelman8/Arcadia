import java.util.Date;
import java.util.Calendar;

class Clock extends Date
{
  Calendar calendar;
  
  Clock()
  {
    calendar = Calendar.getInstance();
    calendar.setTime(this);
  }
  
  public boolean late()
  {
    calendar.setTime(new Date());
    int hour = calendar.get(Calendar.HOUR_OF_DAY);
    return hour >= 22 || hour < 7;
  }
  
  public boolean evening()
  {
    calendar.setTime(new Date());
    int hour = calendar.get(Calendar.HOUR_OF_DAY);
    return hour >= 18 || hour < 22;
  }
}
