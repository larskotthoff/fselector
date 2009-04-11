// rcout.h
//   wrapper function for printing R objects
//   a very simply mimic to C++ standard io stream class
//
/////////////////////////////////////////////////////////////////

#include "rcppbind.h"

class rostream
{
 public: 
  rostream& operator<< ( int n );
  rostream& operator<< ( char *s );
  rostream& operator<< ( double d );
  rostream& operator<< ( rmatrix<typename Type>& rmatrix );
  rostream& operator<< ( rvector<typename Type>& rvector );

  void setFormat( char* pFormat );
 private:
  char m_pFormat[80];
};


template<class TP> class romanip
{
};


inline rostream& operator<< (rostream& o, riomanip<class param>& m)
{
  return m._f(o);
}

#define __DEFINE_RIOMANIP_FN1(type,param,function)			\
	inline rostream& __riomanip_##function (rostream&, param);	\
	inline type<param> function( param n)				\
		{ return type<param> ( __iomanip_##function, n ); }

__DEFINE_RIOMANIP_FN1( romanip, char*, setFormat );

rostream& __riomanip_setFormat( rostream& rstream, char* pFormat )
{
  rstream.setFormat( pFormat );
  return rstream;
}
