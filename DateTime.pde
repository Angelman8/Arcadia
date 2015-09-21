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
    return calendar.get(Calendar.HOUR_OF_DAY) > 22;
  }
  
  public boolean evening()
  {
    calendar.setTime(new Date());
    return calendar.get(Calendar.HOUR_OF_DAY) > 19;
  }
}
