// rmatrix: wrapper template class for R matrix
//
// Gang Liang
//////////////////////////////////////////////////////////////////

#ifndef RMATRIX_H_INCLUDED__
#define RMATRIX_H_INCLUDED__

template<typename T> struct rmatrix_trait
{
  typedef T  datatype;
  typedef T* iterator;
  typedef const T const_datatype;
  typedef const T* const_iterator;
};

template <typename T>
class rmatrix : public robject {
  public:
    typedef typename rmatrix_trait<T>::datatype datatype;
    typedef typename rmatrix_trait<T>::iterator iterator;
    typedef typename rmatrix_trait<T>::const_datatype const_datatype;
    typedef typename rmatrix_trait<T>::const_iterator const_iterator;

    // construction/deconstruction functions
    rmatrix(SEXP sexp);
    rmatrix(int nrow, int ncol);
    rmatrix(T* pdata, int nrow, int ncol);

    // helpers: member access functions
    datatype& operator()(int i, int j);
    iterator  operator[](int col);
    const_datatype& operator()(int i, int j) const;
    const_iterator  operator[](int col) const;
    int nrow(void) const {return nrow_;}
    int ncol(void) const {return ncol_;}
    iterator begin(void) { return pdata_; }
    iterator   end(void) { return pdata_ + nrow_*ncol_; }
    const_iterator begin(void) const { return pdata_; }
    const_iterator   end(void) const { return pdata_ + nrow_*ncol_; }

    // general matrix operation helper functions
    rmatrix<T>& operator  = ( const_datatype& right );
    rmatrix<T>& operator  = ( const rmatrix<T>& right );
    rmatrix<T>& operator *= ( const_datatype& right );
    rmatrix<T>& operator *= ( const rmatrix<T>& right );
    rmatrix<T>& operator += ( const_datatype& right );
    rmatrix<T>& operator += ( const rmatrix<T>& right );
    rmatrix<T>& operator /= ( const rmatrix<T>& right );
    rmatrix<T>& operator -= ( const rmatrix<T>& right );

  private:
    T* pdata_;
    int nrow_, ncol_;
};

//////////////////////////////////////////////////////////////////
// construction/deconstruction functions

template <typename T>
rmatrix<T>::rmatrix(T* pdata, int nrow, int ncol) : nrow_(nrow), ncol_(ncol)
{
  if( nrow < 0 || ncol < 0 )
    throw std::runtime_error( "rmatrix::rmatrix: nrow or ncol out of range.\n" );
  pdata_ = pdata;
}

template <typename T>
rmatrix<T>::rmatrix(SEXP sexp) : robject(sexp)
{
  if( !isMatrix(sexp) )
    throw std::runtime_error( "rmatrix: sexp not a matrix.\n" );

  pdata_ = (T*)DATAPTR(sexp);

  // get dimension attribute
  SEXP dim;
  PROTECT( dim  = getAttrib(sexp, R_DimSymbol) );
  nrow_ = INTEGER(dim)[0];
  ncol_ = INTEGER(dim)[1];
  UNPROTECT(1);
}

template <typename T>
rmatrix<T>::rmatrix(int nrow, int ncol) : nrow_(nrow), ncol_(ncol)
{
  if( nrow < 0 || ncol < 0 )
    throw std::runtime_error( "rmatrix::rmatrix: nrow or ncol out of range.\n" );
  PROTECT( sexp_ = allocMatrix(typeSEXP(typeid(T)), nrow, ncol) );
  pdata_ = reinterpret_cast<iterator>DATAPTR(sexp_);

  setCreatedBit();
  setRObjectBit();
}

//////////////////////////////////////////////////////////////////
// elements access helper functions

template <typename T>
typename rmatrix<T>::datatype& rmatrix<T>::operator()(int nrow, int ncol)
{
  if( nrow < 0 || nrow >= nrow_ )
    throw std::range_error( "rmatrix(nrow, ncol): nrow out of range." );
  if( ncol < 0 || ncol >= ncol_ )
    throw std::range_error( "rmatrix(nrow, ncol): ncol out of range." );
  
  return pdata_[ncol*nrow_ + nrow];
}

template <typename T>
typename rmatrix<T>::iterator rmatrix<T>::operator[] (int ncol)
{
  if( ncol <0 || ncol >= ncol_ )
    throw std::range_error( "rmatrix[ncol]: ncol out of range." );

  return pdata_ + ncol*nrow_;
}

template <typename T>
typename rmatrix<T>::const_iterator rmatrix<T>::operator[] (int ncol) const
{
  if( ncol < 0 || ncol >= ncol_ )
    throw std::range_error( "rmatrix[ncol]: ncol out of range." );

  return pdata_ + ncol*nrow_;
}

//////////////////////////////////////////////////////////////////
// general matrix operation helper functions

template <typename T>
rmatrix<T>& rmatrix<T>::operator = ( typename rmatrix<T>::const_datatype& right )
{
  T* pointer = pdata_;
  int length = nrow_ * ncol_;
  for( int i = 0; i < length; i++ )
    (*pointer++) = right;

  return *this;
}

template <typename T>
rmatrix<T>& rmatrix<T>::operator = ( const rmatrix<T>& right )
{
  if( nrow_ != right.nrow_ || ncol_ != right.ncol_ )
    throw std::runtime_error( "rmatrix1 = rmatrix2: dim does not match." );

  T* p1 = pdata_;
  T* p2 = right.pdata_;
  int length = nrow_ * ncol_;
  // convert to memcopy eventually
  for( int i = 0; i < length; i++ )
    (*p1++) = (*p2++);

  return *this;
}

template <typename T>
rmatrix<T>& rmatrix<T>::operator *= ( typename rmatrix<T>::const_datatype& right )
{
  T* pointer = pdata_;
  int length = nrow_ * ncol_;
  for( int i = 0; i < length; i++ )
    (*pointer++) *= right;

  return *this;
}

template <typename T>
rmatrix<T>& rmatrix<T>::operator *= ( const rmatrix<T>& right )
{
  if( nrow_ != right.nrow_ || ncol_ != right.ncol_ )
    throw std::runtime_error( "rmatrix1 *= rmatrix2: dim does not match." );

  T* pointer  = pdata_;
  T* pRightPtr = right.pdata_;

  int length = nrow_ * ncol_;
  for( int i = 0; i < length; i++ )
    (*pointer++) *= (*pRightPtr++);

  return *this;
}

template <typename T>
rmatrix<T>& rmatrix<T>::operator += ( typename rmatrix<T>::const_datatype& right )
{
  T* pointer = pdata_;
  int length = nrow_ * ncol_;
  for( int i = 0; i < length; i++ )
    (*pointer++) += right;
  return *this;
}

template <typename T>
rmatrix<T>& rmatrix<T>::operator += ( const rmatrix<T>& right )
{
  if( nrow_ != right.nrow_ || ncol_ != right.ncol_ )
    throw std::runtime_error( "rmatrix1 *= rmatrix2: dim does not match." );

  T* pointer  = pdata_;
  T* pRightPtr = right.pdata_;

  int length = nrow_ * ncol_;
  for( int i = 0; i < length; i++ )
    (*pointer++) += (*pRightPtr++);

  return *this;
}

// partial specialization for rmatrix<rdate>
template<>
rmatrix<rdate>::rmatrix(SEXP sexp) : robject(sexp)
{
  if( !isMatrix(sexp) )
    throw std::runtime_error( "rmatrix: sexp not a matrix.\n" );

  if( !inherits(sexp_, "Date") )
    throw std::runtime_error( "operator rmatrix<rdate>: sexp not a date matrix." );

  // convert double to integer
  //   -- internally 'Date' object might be double
  if(isReal(sexp_)) {
    PROTECT( sexp_ = coerceVector(sexp_, INTSXP) );
    setCreatedBit(); // so sexp_ will be UNPROTECT when done.
  }

  pdata_  = reinterpret_cast<rdate*>(DATAPTR(sexp_));

  SEXP dim;
  PROTECT( dim  = getAttrib(sexp, R_DimSymbol) );
  nrow_ = INTEGER(dim)[0];
  ncol_ = INTEGER(dim)[1];
  UNPROTECT(1);
}

template<>
rmatrix<rdate>::rmatrix(int nrow, int ncol) : nrow_(nrow), ncol_(ncol)
{
  if( nrow < 0 || ncol < 0 )
    throw std::runtime_error( "rmatrix::rmatrix: nrow or ncol -- out of range.\n" );

  // create R object
  PROTECT( sexp_ = allocMatrix( INTSXP, nrow, ncol) );
  pdata_ = reinterpret_cast<iterator>(DATAPTR(sexp_));
  setCreatedBit();
  setRObjectBit();
  setClass("Date");
}

// partial specialization for rmatrix<rtime>
template<>
rmatrix<rtime>::rmatrix(SEXP sexp) : robject(sexp)
{
  if( !isVector(sexp_) )
    throw std::runtime_error( "operator rmatrix<rtime>: Input sexp is not a vector." );

  // it is impossible to have a vector of "POSIXlt" objects
  if( !inherits(sexp_, "POSIXct") )
    throw std::runtime_error( "operator rmatrix<rtime>: sexp not a time vector." );

  // convert integer to double if neccessary
  //   -- internally 'POSIXct' might be integer sometimes
  if(isInteger(sexp_)) {
    PROTECT( sexp_ = coerceVector(sexp_, REALSXP) );
    setCreatedBit();
  }

  pdata_  = reinterpret_cast<iterator>(DATAPTR(sexp_));

  SEXP dim;
  PROTECT( dim  = getAttrib(sexp, R_DimSymbol) );
  nrow_ = INTEGER(dim)[0];
  ncol_ = INTEGER(dim)[1];
  UNPROTECT(1);
}

template<>
rmatrix<rtime>::rmatrix(int nrow, int ncol) : nrow_(nrow), ncol_(ncol)
{
  if( nrow < 0 || ncol < 0 )
    throw std::runtime_error( "rmatrix::rmatrix: nrow or ncol -- out of range.\n" );

  // create R object
  PROTECT( sexp_ = allocMatrix( REALSXP, nrow, ncol) );
  pdata_ = reinterpret_cast<iterator>(DATAPTR(sexp_));
  setCreatedBit();
  setRObjectBit();
  setClass("POSIXct");
}

#endif  //RMATRIX_H_INCLUDED__
