// rsexp.h: wrapper class for SEXP struct.
//
//   Design a uniform interface for template classes, i.e.,
//   automatic type conversion.
//
// Syntax: 
//
//   int(rsexp(sexp));
//   rvector<int>(rsexp(sexp));
//
// It is the user's responsibility to ensure the conversion
// is meaningful, otherwise, an exception will be thrown.
//
/////////////////////////////////////////////////////////////////////


#ifndef RSEXP_H_INCLUDED__
#define RSEXP_H_INCLUDED__

class rsexp {
  public:
    rsexp(const SEXP sexp) : sexp_(sexp) {}
    operator SEXP() { return sexp_; }
    operator const SEXP() const { return sexp_; }

    // general conversion rule
    //   -- rlist, rdataframe, rvector<T>, rmatrix<T>, etc
    template<typename T> operator const T() { return T(sexp_); }

    // conversion rules for primitive types: special
    //   -- int, double, char*, Rcomplex, logical
    operator const int();
    operator const double();
    operator const char*();
    operator const Rcomplex();

  private:
    SEXP sexp_;
};

rsexp::operator const char*()
{
  if( !isVector(sexp_) )
    throw std::runtime_error( "operator char*: Input sexp is not a vector." );

  if( LENGTH(sexp_) != 1 )
    throw std::runtime_error( "operator char*: Length of sexp is greater than 1." );

  if( !isString(sexp_) )
    throw std::runtime_error( "operator char*: Input sexp is not a character string.");

  return CHAR(sexp_);
}

rsexp::operator const Rcomplex()
{
  if( !isVector(sexp_) )
    throw std::runtime_error( "operator Rcomplex: Input sexp is not a vector." );

  if( LENGTH(sexp_) != 1 )
    throw std::runtime_error( "operator Rcomplex: Length of input sexp is larger than 1." );

  // check type, make necessary conversions
  Rcomplex retValue;
  if( isComplex(sexp_) )
    retValue = COMPLEX(sexp_)[0];
  else if( isInteger(sexp_) || isReal(sexp_) ) { // convert both int and double to complex
    PROTECT( sexp_ = coerceVector(sexp_, CPLXSXP) );
    retValue = COMPLEX(sexp_)[0];
    UNPROTECT(1);
  } else
    throw std::runtime_error( "operator Rcomplex: Input sexp is not a valid type for Rcomplex.");

  return retValue;
}

rsexp::operator const double()
{
  if( !isVector(sexp_) )
    throw std::runtime_error( "operator double: Input sexp is not a vector." );

  if( length(sexp_) != 1 )
    throw std::runtime_error( "operator double: Length of input sexp is greater than 1." );

  // check type, make necessary conversions
  double retValue;
  if ( isReal(sexp_) )
    retValue = REAL(sexp_)[0];
  else if ( isInteger(sexp_) ) { // only convert int to double
    PROTECT( sexp_ = coerceVector(sexp_, REALSXP) );
    retValue = REAL(sexp_)[0];
    UNPROTECT(1);
  } else
    throw std::runtime_error( "operator double: Input sexp is not a valid type for double.");

  return retValue;
}

rsexp::operator const int()
{
  if( !isVector(sexp_) )
    throw std::runtime_error( "operator int: Input sexp not a vector." );

  if( length(sexp_) != 1 )
    throw std::runtime_error( "operator int: Length of input sexp is greater than 1." );

  if( !isInteger(sexp_) )
    throw std::runtime_error( "operator int: Input sexp is not an integer.");

  return INTEGER(sexp_)[0];
}

#endif // RSEXP_H_INCLUDED__
