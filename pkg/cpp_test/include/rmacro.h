#ifndef R_MACRO_INCLUDED__
#define R_MACRO_INCLUDED__

#define CATCH_BLOCK \
  catch(std::exception& ex) \
  { \
    rstring strerr( ex.what() );\
    error( strerr ); \
  } \
  catch(...) \
  { \
    error( "Unknown exception." ); \
  } \
  return sexp;

#define RCPP0(modulename) \
  /* a dummy variable SEXP is used to overload the function */ \
  extern "C" { SEXP modulename(SEXP); } \
  SEXP modulename(void); \
  SEXP modulename(SEXP) \
  { \
    try { \
      sexp = modulename(); \
    } \
    CATCH_BLOCK \
  }

#define RCPP1(modulename, T1) \
  extern "C" { SEXP modulename(SEXP p1); } \
  SEXP modulename(const T1& t1); \
  SEXP modulename(SEXP p1) \
  { \
    T1 p1_ = rsexp(p1); \
    SEXP sexp = NULL; \
    try { \
      sexp = modulename( p1_ ); \
    } \
    CATCH_BLOCK \
  }

#define RCPP2(modulename, T1, T2) \
  extern "C" { SEXP modulename(SEXP, SEXP); } \
  SEXP modulename(const T1&, const T2&); \
  SEXP modulename(SEXP p1) \
  { \
    T1 p1_ = rsexp(p1); \
    T2 p2_ = rsexp(p2); \
    SEXP sexp; \
    try { \
      sexp = modulename( p1_, p2_ ); \
    } \
    CATCH_BLOCK \
  }

#define RCPP3(modulename, T1, T2, T3) \
  extern "C" { SEXP modulename(SEXP, SEXP, SEXP); } \
  SEXP modulename(const T1&, const T2&, const T3&); \
  SEXP modulename(SEXP p1, SEXP p2, SEXP p3) \
  { \
    T1 p1_ = rsexp(p1); \
    T2 p2_ = rsexp(p2); \
    T3 p3_ = rsexp(p3); \
    SEXP sexp; \
    try { \
      sexp = modulename( p1_, p2_, p3_ ); \
	} \
    CATCH_BLOCK \
  }

#define RCPP4(modulename, T1, T2, T3, T4) \
  extern "C" { SEXP modulename(SEXP, SEXP, SEXP, SEXP); } \
  SEXP modulename(const T1&, const T2&, const T3&, const T4&); \
  SEXP modulename(SEXP p1, SEXP p2, SEXP p3, SEXP p4) \
  { \
    T1 p1_ = rsexp(p1); \
    T2 p2_ = rsexp(p2); \
    T3 p3_ = rsexp(p3); \
    T4 p4_ = rsexp(p4); \
    SEXP sexp; \
    try { \
      sexp = modulename( p1_, p2_, p3_, p4_ ); \
    } \
    CATCH_BLOCK \
  }

#define RCPP5(modulename, T1, T2, T3, T4, T5) \
  extern "C" { SEXP modulename(SEXP, SEXP, SEXP, SEXP, SEXP); } \
  SEXP modulename(const T1&, const T2&, const T3&, const T4&, const T5&); \
  SEXP modulename(SEXP p1, SEXP p2, SEXP p3, SEXP p4, SEXP p5) \
  { \
    T1 p1_ = rsexp(p1); \
    T2 p2_ = rsexp(p2); \
    T3 p3_ = rsexp(p3); \
    T4 p4_ = rsexp(p4); \
    T5 p5_ = rsexp(p5); \
    SEXP sexp; \
    try { \
      sexp = modulename( p1_, p2_, p3_, p4_, p5_ ); \
    } \
    CATCH_BLOCK \
  }

#define RCPP6(modulename, T1, T2, T3, T4, T5, T6) \
  extern "C" { SEXP modulename(SEXP, SEXP, SEXP, SEXP, SEXP, SEXP); } \
  SEXP modulename(const T1&, const T2&, const T3&, const T4&, const T5&, const T6&); \
  SEXP modulename(SEXP p1, SEXP p2, SEXP p3, SEXP p4, SEXP p5, SEXP p6) \
  { \
    T1 p1_ = rsexp(p1); \
    T2 p2_ = rsexp(p2); \
    T3 p3_ = rsexp(p3); \
    T4 p4_ = rsexp(p4); \
    T5 p5_ = rsexp(p5); \
    T6 p6_ = rsexp(p6); \
    SEXP sexp; \
    try { \
      sexp = modulename( p1_, p2_, p3_, p4_, p5_, p6_ ); \
    } \
    CATCH_BLOCK \
  }

#define RCPP7(modulename, T1, T2, T3, T4, T5, T6, T7) \
  extern "C" { SEXP modulename(SEXP, SEXP, SEXP, SEXP, SEXP, SEXP, SEXP); } \
  SEXP modulename(const T1&, const T2&, const T3&, const T4&, const T5&, const T6&, const T7&); \
  SEXP modulename(SEXP p1, SEXP p2, SEXP p3, SEXP p4, SEXP p5, SEXP p6, SEXP p7) \
  { \
    T1 p1_ = rsexp(p1); \
    T2 p2_ = rsexp(p2); \
    T3 p3_ = rsexp(p3); \
    T4 p4_ = rsexp(p4); \
    T5 p5_ = rsexp(p5); \
    T6 p6_ = rsexp(p6); \
    T7 p7_ = rsexp(p7); \
    SEXP sexp; \
    try { \
      sexp = modulename( p1_, p2_, p3_, p4_, p5_, p6_, p7_ ); \
    } \
    CATCH_BLOCK \
  }

#define RCPP8(modulename, T1, T2, T3, T4, T5, T6, T7, T8) \
  extern "C" { SEXP modulename(SEXP, SEXP, SEXP, SEXP, SEXP, SEXP, SEXP, SEXP); } \
  SEXP modulename(const T1&, const T2&, const T3&, const T4&, const T5&, const T6&, const T7&, const T8&); \
  SEXP modulename(SEXP p1, SEXP p2, SEXP p3, SEXP p4, SEXP p5, SEXP p6, SEXP p7, SEXP p8) \
  { \
    T1 p1_ = rsexp(p1); \
    T2 p2_ = rsexp(p2); \
    T3 p3_ = rsexp(p3); \
    T4 p4_ = rsexp(p4); \
    T5 p5_ = rsexp(p5); \
    T6 p6_ = rsexp(p6); \
    T7 p7_ = rsexp(p7); \
    T8 p8_ = rsexp(p8); \
    SEXP sexp; \
    try { \
      sexp = modulename( p1_, p2_, p3_, p4_, p5_, p6_, p7_, p8_ ); \
    } \
    CATCH_BLOCK \
  }

#define RCPP9(modulename, T1, T2, T3, T4, T5, T6, T7, T8, T9) \
  extern "C" { SEXP modulename(SEXP, SEXP, SEXP, SEXP, SEXP, SEXP, SEXP, SEXP, SEXP); } \
  SEXP modulename(const T1&, const T2&, const T3&, const T4&, const T5&, const T6&, const T7&, const T8&, const T9&); \
  SEXP modulename(SEXP p1, SEXP p2, SEXP p3, SEXP p4, SEXP p5, SEXP p6, SEXP p7, SEXP p8, SEXP p9) \
  { \
    T1 p1_ = rsexp(p1); \
    T2 p2_ = rsexp(p2); \
    T3 p3_ = rsexp(p3); \
    T4 p4_ = rsexp(p4); \
    T5 p5_ = rsexp(p5); \
    T6 p6_ = rsexp(p6); \
    T7 p7_ = rsexp(p7); \
    T8 p8_ = rsexp(p8); \
    T9 p9_ = rsexp(p9); \
    SEXP sexp; \
    try { \
      sexp = modulename( p1_, p2_, p3_, p4_, p5_, p6_, p7_, p8_, p9_ ); \
    } \
    CATCH_BLOCK \
  }

#endif // R_MACRO_INCLUDED__
