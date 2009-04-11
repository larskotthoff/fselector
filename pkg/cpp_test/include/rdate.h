// rdate.h
//   a wrapper of Date object ('int' internally)
//
// Gang Liang
/////////////////////////////////////////////////////////////////


#ifndef R_DATE_H_INCLUDED__
#define R_DATE_H_INCLUDED__

class rdate
{
  public:
    rdate(int date) : date_(date) {}

    void time(struct tm& tm) const { return date2tm(date_, tm);}
    int operator-(const rdate& obj) const { return date_ - obj.date_; }
    rdate operator+(int datediff) const { return date_ + datediff; }

    static void date2tm(int date, struct tm& tm);
    static int tm2date(const struct tm& tm);
  private:
    int date_;
};

// code stolen from the R implementation
static const int days_in_month[12] =
{31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};

#define isleap(y) ((((y) % 4) == 0 && ((y) % 100) != 0) || ((y) % 400) == 0)
#define days_in_year(year) (isleap(year) ? 366 : 365)

void rdate::date2tm(int date, struct tm& tm)
{
  if( !isfinite(date) ) {
    tm.tm_hour = tm.tm_min = tm.tm_sec = tm.tm_mday =
      tm.tm_mon = tm.tm_year = tm.tm_wday = tm.tm_yday =
      NA_INTEGER;
    return;
  }

  int day = date, y = 1970, tmp;
  tm.tm_hour = tm.tm_min = tm.tm_sec = 0;

  /* weekday: 1970-01-01 was a Thursday */
  if ((tm.tm_wday = ((4 + day) % 7)) < 0) tm.tm_wday += 7;

  /* year & day within year */
  // i have to say that the code is ugly
  if (day >= 0)
    for ( ; day >= (tmp = days_in_year(y)); day -= tmp, y++);
  else
    for ( ; day < 0; --y, day += days_in_year(y) );

  tm.tm_year = y - 1900;
  tm.tm_yday = day;

  /* month within year */
  int mon;
  for (mon = 0;
      day >= (tmp = (days_in_month[mon]) +
        ((mon==1 && isleap(y))?1:0));
      day -= tmp, mon++);
  tm.tm_mon = mon;
  tm.tm_mday = day + 1;
  tm.tm_isdst = 0; /* no dst in GMT */
}

#endif // R_DATE_H_INCLUDED__
