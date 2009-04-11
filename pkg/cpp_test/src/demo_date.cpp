#include <rcppbind.h>

RCPP1(demo_date, rvector<rdate>);

SEXP demo_date(const rvector<rdate>& datevec)
{
  struct tm tm;
  const rdate* end = datevec.end();

  // display the input date vector
  for(const rdate* ptr = datevec.begin(); ptr < end; ++ptr) {
    ptr->time(tm);
    Rprintf("%04d-%02d-%02d\n", tm.tm_year + 1900, tm.tm_mon
        + 1, tm.tm_mday);
  }

  // new date vector: 10 days later than the original one
  rvector<rdate> newdate(datevec.length());
  for(int i = 0; i < datevec.length(); i++)
    newdate[i] = datevec[i] + 10;

  return newdate;
}
