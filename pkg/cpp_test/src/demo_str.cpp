#include <rcppbind.h>

RCPP1(demo_str, rvector<rstring>);

SEXP demo_str(const rvector<rstring>& strvec)
{
  // display the input character vector
  for( int i = 0; i < strvec.length(); i++ )
    Rprintf( "%d: \"%s\"\n", i, strvec[i].c_str() );

  // return another character vector
  rvector<rstring> retobj(3);
  rvector<rstring>::iterator iter = retobj.begin();
  *iter++ = rstring("programming");
  *iter++ = rstring("is");
  *iter++ = rstring("fun.");

  return retobj;
}
