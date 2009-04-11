// rdataframe: wrapper function for R data.frame object
//
// Gang Liang
//////////////////////////////////////////////////////////////////

#ifndef DATA_FRAME_H_INCLUDED__
#define DATA_FRAME_H_INCLUDED__

class rdataframe : public robject {
  public:
    // construction/deconstruction function
    inline rdataframe( SEXP sexp );         // wrap an existing SEXP
    inline rdataframe( int, int, const std::vector<const std::type_info*>&,
      const std::vector<std::string>& );    // create a new data.frame object
    inline virtual ~rdataframe(void);

    // helper: component access functions (member templates)
    template <typename T> inline rvector<T> getColumn( int  index );
    template <typename T> inline rvector<T> getColumn( const std::string& colname );
    template <typename T> inline const rvector<T> getColumn( int  index ) const;
    template <typename T> inline const rvector<T> getColumn( const std::string& colname ) const;
    inline SEXPTYPE getColType(int index) const;
    inline SEXPTYPE getColType(const std::string& colname) const;

    // helper: attributes access
    int nrow(void) const { return nrow_; }
    int ncol(void) const { return ncol_; }
    const std::vector<std::string>& getColNames(void) const { return colnames_; }
    inline void setColNames(const std::vector<std::string>& strs);

  private:
    int nrow_;
    int ncol_;
    std::vector<std::string> colnames_;
    std::vector<SEXP> sexpvec_;
};

//////////////////////////////////////////////////////////////////
// construction/deconstruction function

rdataframe::rdataframe(SEXP sexp) : robject(sexp)
{
  if( !isFrame(sexp_) )
    std::runtime_error( "rdataframe::rdataframe(sexp): not a data.frame.\n" );

  ncol_ = LENGTH(sexp);
  if ( ncol_ == 0 )
    std::runtime_error( "rdataframe::rdataframe(sexp): NULL data.frame.\n" );

  // obtain the colnames, information
  SEXP rowNames = getAttrib(sexp_, R_RowNamesSymbol);
  nrow_ = LENGTH(rowNames);

  colnames_.resize(ncol_);
  SEXP colNames = getAttrib(sexp_, R_NamesSymbol);
  if (colNames != R_NilValue ) {
    for( int i = 0; i < ncol_; ++i ) {
      SEXP colname = VECTOR_ELT(colNames,i);
      if (colname != R_NilValue) colnames_[i] = CHAR(colname);
    }
  }
}

rdataframe::rdataframe( int nrow, int ncol, const
    std::vector<const std::type_info*>& colType, const
    std::vector<std::string>& colnames ) : nrow_(nrow), ncol_(ncol)
{
  if ( ncol < 0 || nrow < 0 )
    std::runtime_error( "rdataframe::rdataframe: nrow or ncol out of range.\n" );

  if( colnames.size() != (unsigned)ncol_ )
    throw std::runtime_error("rdataframe::rdataframe: the size of colname mismatch.");

  if( colType.size() != (unsigned)ncol_ )
    throw std::runtime_error("rdataframe::rdataframe: the size of colType mismatch.");

  // create a list object of length ncol_
  PROTECT( sexp_ = allocVector(VECSXP, ncol_) );
  colnames_.resize(ncol_);
  colnames_ = colnames;
  
  // create data vectors and insert into the data.frame
  SEXP sexp;
  sexpvec_.resize(ncol_);
  for( int i = 0; i < ncol_; ++i )
  {
    // handle each type accordingly
    if( *colType[i] == typeid(double) )
      PROTECT(sexp = allocVector(REALSXP, nrow_));
    else if( *colType[i] == typeid(Rcomplex) )
      PROTECT(sexp = allocVector(CPLXSXP, nrow_));
    else if( *colType[i] == typeid(int) )
      PROTECT(sexp = allocVector(INTSXP, nrow_));
    else if( *colType[i] == typeid(rstring) ) {
      PROTECT(sexp = allocVector(STRSXP, nrow_));
    } else if( *colType[i] == typeid(rdate) ) {
      PROTECT(sexp = allocVector(INTSXP, nrow_));
      robject::setClass(sexp, "Date");
    } else if( *colType[i] == typeid(rtime) ) {
      PROTECT(sexp = allocVector(REALSXP, nrow_));
      robject::setClass(sexp, "POSIXlt");
    } else
      throw std::runtime_error("rdataframe::rdataframe: unsupported typeid.");

    sexpvec_[i] = sexp;
    SET_VECTOR_ELT(sexp_, i, sexp);
  }

  setCreatedBit();
  setRObjectBit();
  setClass("data.frame");
  setNames(colnames);
  setRowNames(nrow_);
}

rdataframe::~rdataframe(void)
{
  // the main rlist object will be unprotected in ~robject.
  // unprotect all column data vectors
  if(isCreated()) {
    std::vector<SEXP>::iterator iter = sexpvec_.begin();
    std::vector<SEXP>::iterator end  = sexpvec_.end();
    while(iter < end) UNPROTECT_PTR(*iter++);
  }
}

//////////////////////////////////////////////////////////////////
// member selection functions

template <typename T>
rvector<T> rdataframe::getColumn( int index )
{
  if ( index < 0 || index > ncol_ )
    throw std::range_error( "rdataframe::getColumn: index out of range." );

  SEXP sexp = VECTOR_ELT( sexp_, index );
  return rvector<T>(sexp);
}

template <typename T>
const rvector<T> rdataframe::getColumn( int index ) const
{
  if ( index < 0 || index > ncol_ )
    throw std::range_error( "rdataframe::getColumn: index out of range." );

  SEXP sexp = VECTOR_ELT( sexp_, index );
  return rvector<T>(sexp);
}

template <typename T>
rvector<T> rdataframe::getColumn( const std::string& colname )
{
  // scan the colnames for the matching column
  for ( int i = 0; i < ncol_; i++ ) {
    if( colname == colnames_[i] )
      return rvector<T>(VECTOR_ELT(sexp_, i));
  }
  
  // throw an error if no object found
  std::string msg = "rdataframe::getColumn: ";
  throw std::runtime_error(  msg + colname + " no found." );
  return rvector<T>(R_NilValue); // -Wall
}

template <typename T>
const rvector<T> rdataframe::getColumn( const std::string& colname ) const
{
  // scan the colnames for the matching column
  for ( int i = 0; i < ncol_; i++ ) {
    if( colname == colnames_[i] )
      return rvector<T>(VECTOR_ELT(sexp_, i));
  }
  
  // throw an error if no object found
  std::string msg = "rdataframe::getColumn: ";
  throw std::runtime_error(  msg + colname + " no found." );
  return rvector<T>(R_NilValue); // -Wall
}

void rdataframe::setColNames(const std::vector<std::string>& strs)
{
  if ( strs.size() != (unsigned)ncol_ )
    throw std::range_error( "rdataframe::setColNames: length does not match." );

  SEXP colNames;
  PROTECT( colNames = allocVector(STRSXP, ncol_) );
  for( int i = 0; i < ncol_; ++i )
    SET_VECTOR_ELT( colNames, i, mkChar(strs[i].c_str()) );
  setAttrib( sexp_, R_NamesSymbol, colNames );
  UNPROTECT(1);
}

SEXPTYPE rdataframe::getColType(int index) const
{
  if ( index < 0 || index > ncol_ )
    throw std::range_error( "rdataframe::getColType: index out of range." );

  SEXP sexp = VECTOR_ELT( sexp_, index );
  return TYPEOF(sexp);
}

SEXPTYPE rdataframe::getColType(const std::string& colname) const
{
  // scan the colnames for the matching column
  for ( int i = 0; i < ncol_; i++ ) {
    if( colname == colnames_[i] )
      return TYPEOF( VECTOR_ELT(sexp_,i) );
  }
  
  // throw an error if object not found
  std::string msg = "rdataframe::getColType";
  throw std::runtime_error(  msg + colname + " not found." );
  return NILSXP; // -Wall
}

#endif // DATA_FRAME_H_INCLUDED__
