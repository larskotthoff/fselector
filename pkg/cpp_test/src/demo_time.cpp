#include <rcppbind.h>

RCPP1(demo_time, rvector<rtime>);

SEXP demo_time(const rvector<rtime>& timevec)
{
  struct tm tm;
  const rtime* end = timevec.end();
  for(const rtime* ptr = timevec.begin(); ptr < end; ++ptr)
  {
    ptr->time(tm);
    Rprintf("%04d-%02d-%02d %02d:%02d:%02d\n", tm.tm_year +
        1900, tm.tm_mon + 1, tm.tm_mday, tm.tm_hour,
        tm.tm_min, tm.tm_sec);
  }

  return timevec;
}
