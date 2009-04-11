// rvector.h: wrapper template class for R vector object
//
//   many types are viewed as vector object:
//     INTSXP, REALSXP, STRSXP, LGLSXP, CPLSXP, VECSXP
//
// Gang Liang
//////////////////////////////////////////////////////////////////

#ifndef RVECTOR_H_INCLUDED__
#define RVECTOR_H_INCLUDED__

#include <rcomplex.h>

template<typename T> struct rvector_trait
{
  typedef T  datatype;
  typedef T* iterator;
  typedef const T const_datatype;
  typedef const T* const_iterator;
};

template <typename T>
class rvector : public robject
{
  public:
    typedef typename rvector_trait<T>::datatype datatype;
    typedef typename rvector_trait<T>::iterator iterator;
    typedef typename rvector_trait<T>::const_datatype const_datatype;
    typedef typename rvector_trait<T>::const_iterator const_iterator;

    // construction/deconstruction functions
    rvector(SEXP sexp);             // wrap an existing SEXP
    rvector(int length);            // create an SEXP object
    rvector(iterator pdata, int length);  // memory wrapper only

    // helpers: member access
    datatype& operator [] ( int index );
    const_datatype& operator [] ( int index ) const;
    iterator begin(void) { return pdata_; }
    iterator   end(void) { return pdata_ + length_; }
    const iterator begin(void) const { return pdata_;}
    const iterator   end(void) const { return pdata_ + length_;}
    int length(void) const { return length_; }

    // helpers: general vector operations
    rvector<T>& operator  = ( const T& right );
    rvector<T>& operator  = ( const rvector<T>& right );
    rvector<T>& operator *= ( const T& right );
    rvector<T>& operator *= ( const rvector<T>& right );
    rvector<T>& operator += ( const T& right );
    rvector<T>& operator += ( const rvector<T>& right );
    rvector<T>& operator -= ( const rvector<T>& right );

  private:
    iterator pdata_;
    int length_;
};

//////////////////////////////////////////////////////////////////
// construction/deconstruction functions

template <typename T>
rvector<T>::rvector(SEXP sexp) : robject(sexp)
{
  // check whether sexp is a vector object in R
  if( !isVector(sexp) )
    throw std::runtime_error( "rvector<T>::rvector: SEXP is not a vector." );

  // check data type
  if ( TYPEOF(sexp) != robject::typeSEXP(typeid(T)) )
    throw std::runtime_error( "rvector<T>::rvector: SEXP is not of the right type." );

  pdata_  = reinterpret_cast<iterator>(DATAPTR(sexp_));
  length_ = LENGTH(sexp_);
}

template <typename T>
rvector<T>::rvector(int length) : length_(length)
{
  if( length < 0 )
    throw std::runtime_error( "rvector<T>::rvector: negative length." );

  // create R object
  PROTECT( sexp_ = allocVector( typeSEXP(typeid(T)), length) );
  pdata_ = reinterpret_cast<iterator>(DATAPTR(sexp_));

  setCreatedBit();
  setRObjectBit();
}

template <typename T>
rvector<T>::rvector(iterator pdata, int length)
: pdata_(pdata), length_(length)
{
  if( length < 0 )
    throw std::runtime_error( "rvector<T>::rvector: negative length." );

  if( pdata == NULL ) 
    throw std::runtime_error( "rvector<T>::rvector: zero data pointer." );
}

//////////////////////////////////////////////////////////////////
// helpers: elements access

template <typename T>
typename rvector<T>::datatype& rvector<T>::operator[] (int index)
{
  if( index < 0 || index >= length_ )
    throw std::range_error( "rvector[index]: index is out of range." );

  return pdata_[index];
}

template <typename T>
typename rvector<T>::const_datatype& rvector<T>::operator[] (int index) const
{
  if( index < 0 || index >= length_ )
    throw std::range_error( "rvector[index]: index is out of range." );

  return pdata_[index];
}

//////////////////////////////////////////////////////////////////
// helpers: general matrix operations

template <typename T>
rvector<T>& rvector<T>::operator = ( const T& right )
{
  T* pointer = pdata_;
  for( int i = 0; i < length_; ++i )
    *pointer++ = right;

  return *this;
}

template <typename T>
rvector<T>& rvector<T>::operator = ( const rvector<T>& right )
{
  if( length_ != right.length_ )
    throw std::range_error( "rvector::operator=: length mismatch." );

  T* lptr = pdata_;
  T* rptr = right.pdata_;

  for( int i = 0; i < length_; i++ )
    (*lptr++) = (*rptr++);

  return *this;
}

template <typename T>
rvector<T>& rvector<T>::operator *= ( const T& right )
{
  T* pointer = pdata_;
  for( int i = 0; i < length_; i++ )
    (*pointer++) *= right;
  return *this;
}


template <typename T>
rvector<T>& rvector<T>::operator *= ( const rvector<T>& right )
{
  if( length_ != right.length_ )
    throw std::range_error( "rvector::operator*=: length mismatch." );

  T* lptr = pdata_;
  T* rptr = right.pdata_;

  for( int i = 0; i < length_; i++ )
    (*lptr++) *= (*rptr++);

  return *this;
}

template <typename T>
rvector<T>& rvector<T>::operator += ( const T& right )
{
  T* pointer = pdata_;
  for( int i = 0; i < length_; i++ )
    (*pointer++) += right;
  return *this;
}


template <typename T>
rvector<T>& rvector<T>::operator += ( const rvector<T>& right )
{
  if( length_ != right.length_ )
    throw std::range_error( "rvector::operator+=: length mismatch." );

  T* lptr = pdata_;
  T* rptr = right.pdata_;

  for( int i = 0; i < length_; i++ )
    (*lptr++) += (*rptr++);

  return *this;
}

template <typename T>
rvector<T>& rvector<T>::operator -= ( const rvector<T>& right )
{
  if( length_ != right.length_ )
    throw std::range_error( "rvector::operator-=: length mismatch." );

  T* lptr = pdata_;
  T* rptr = right.pdata_;

  for( int i = 0; i < length_; i++ )
    (*lptr++) -= (*rptr++);

  return *this;
}

///////////////////////////////////////////////////////////
// partial specialization for rvector<rdate>

template <>
rvector<rdate>::rvector(SEXP sexp) : robject(sexp)
{
  if( !isVector(sexp_) )
    throw std::runtime_error( "operator rvector<rdate>: Input sexp is not a vector." );

  // it is impossible to have a vector of "POSIXlt" objects
  if( !inherits(sexp_, "Date") )
    throw std::runtime_error( "operator rvector<rdate>: sexp not a date vector." );

  // convert double to integer if possible
  //   -- internally 'Date' might be a real vector sometimes
  if(isReal(sexp_)) {
    PROTECT( sexp_ = coerceVector(sexp_, INTSXP) );
    setCreatedBit();
  }
  // convert Date to POSIXct as well?

  pdata_  = reinterpret_cast<iterator>(DATAPTR(sexp_));
  length_ = LENGTH(sexp_);
}

template<>
rvector<rdate>::rvector(int length) : length_(length)
{
  if( length < 0 )
    throw std::runtime_error( "rvector<rdate>::rvector: negative length." );

  // create R object
  PROTECT( sexp_ = allocVector( INTSXP, length) );
  pdata_ = reinterpret_cast<iterator>(DATAPTR(sexp_));
  setCreatedBit();
  setRObjectBit();
  setClass("Date");
}

///////////////////////////////////////////////////////////
// partial specialization for rvector<rdate>

template <>
rvector<rtime>::rvector(SEXP sexp) : robject(sexp)
{
  if( !isVector(sexp_) )
    throw std::runtime_error( "rvector<rtime>: Input sexp is not a vector." );

  // it is impossible to have a vector of "POSIXlt" objects
  if( !inherits(sexp_, "POSIXct") )
    throw std::runtime_error( "rvector<rtime>: sexp not a time vector." );

  // convert integer to double if neccessary
  //   -- internally 'POSIXct' might be integer sometimes
  if(isInteger(sexp_)) {
    PROTECT( sexp_ = coerceVector(sexp_, REALSXP) );
    setCreatedBit();
  }
  // convert Date to POSIXct as well?

  pdata_  = reinterpret_cast<iterator>(DATAPTR(sexp_));
  length_ = LENGTH(sexp_);
}

template <>
rvector<rtime>::rvector(int length) : length_(length)
{
  if( length < 0 )
    throw std::runtime_error( "rvector<rtime>::rvector: negative length." );

  // create R object
  PROTECT( sexp_ = allocVector( REALSXP, length) );
  pdata_ = reinterpret_cast<iterator>(DATAPTR(sexp_));
  setCreatedBit();
  setRObjectBit();
  setClass( "POSIXct" );
}

#endif  //VECTOR_H_FOR_R_INCLUDED__
