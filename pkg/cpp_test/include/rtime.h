// rtime.h
//   a wrapper of POSIXt object ('double' internally)
//   timezone information is NOT considered
//
// Gang Liang
/////////////////////////////////////////////////////////////////


#ifndef R_DATETIME_H_INCLUDED__
#define R_DATETIME_H_INCLUDED__

class rtime
{
  public:
    void time(struct tm& tm) const
      { return time2tm(time_, tm); }
    double operator-(const rtime& obj) const
      { return time_ - obj.time_; }
    rtime operator+(double timediff) const
      { rtime obj; obj.time_ = time_ + timediff; return obj;}

    static void time2tm(double time, struct tm& tm);
    static double tm2time(const struct tm& tm);
  private:
    double time_;
};

// code stolen from the R implementation
/* Substitute for mktime -- no checking, always in GMT */
double rtime::tm2time(const struct tm& tm)
{
  struct tm ltm = tm;
  int day = 0;
  int i, year, year0;
  double excess = 0.0;

  day = ltm.tm_mday - 1;
  year0 = 1900 + ltm.tm_year;
  /* safety check for unbounded loops */
  if (year0 > 3000) {
    excess = (int)(year0/2000) - 1;
    year0 -= excess * 2000;
  } else if (year0 < 0) {
    excess = -1 - (int)(-year0/2000);
    year0 -= excess * 2000;
  }

  for(i = 0; i < ltm.tm_mon; i++) day += days_in_month[i];
  if (ltm.tm_mon > 1 && isleap(year0)) day++;
  ltm.tm_yday = day;

  if (year0 > 1970) {
    for (year = 1970; year < year0; year++)
      day += days_in_year(year);
  } else if (year0 < 1970) {
    for (year = 1969; year >= year0; year--)
      day -= days_in_year(year);
  }

  /* weekday: Epoch day was a Thursday */
  if ((ltm.tm_wday = (day + 4) % 7) < 0) ltm.tm_wday += 7;

  return ltm.tm_sec + (ltm.tm_min * 60) + (ltm.tm_hour * 3600)
    + (day + excess * 730485) * 86400.0;
}

void rtime::time2tm(double d, struct tm& tm)
{
  int day;
  int y, tmp, mon, left;

  day = (int) floor(d/86400.0);
  left = (int) (d - day * 86400.0 + 0.5);

  /* hour, min, and sec */
  tm.tm_hour = left / 3600;
  left %= 3600;
  tm.tm_min = left / 60;
  tm.tm_sec = left % 60;

  /* weekday: 1970-01-01 was a Thursday */
  if ((tm.tm_wday = ((4 + day) % 7)) < 0) tm.tm_wday += 7;

  /* year & day within year */
  y = 1970;
  if (day >= 0)
    for ( ; day >= (tmp = days_in_year(y)); day -= tmp, y++);
  else
    for ( ; day < 0; --y, day += days_in_year(y) );

  y = tm.tm_year = y - 1900;
  tm.tm_yday = day;

  /* month within year */
  for (mon = 0;
      day >= (tmp = (days_in_month[mon]) + ((mon==1 && isleap(y+1900))?1:0));
      day -= tmp, mon++);
  tm.tm_mon = mon;
  tm.tm_mday = day + 1;

  tm.tm_isdst = 0;
  return;
}

#endif // R_DATE_H_INCLUDED__
