// rcppbind.h
//   The only header file to be included in a project
//
// Gang Liang
///////////////////////////////////////////////////////////

#define USE_RINTERNALS

#include <R.h>
#include <Rinternals.h>
#include <typeinfo>
#include <stdexcept>
#include <vector>
#include <string>
#include <time.h>
#include <cstring>
#include <cstdio>

#include <rcomplex.h>
#include <rdate.h>
#include <rtime.h>
#include <rstring.h>
#include <robject.h>
#include <rvector.h>
#include <rmatrix.h>
#include <rlist.h>
#include <rdata.frame.h>
#include <rmacro.h>
#include <rsexp.h>

//#include <rcout.h>
