// rlist.h: wrapper class for R list object
//
// NOTE: because the internal change of R, the implementation
//   of list object is no longer pairlist as in Lisp. Now the new
//   construction is based on generic vectors. Accordingly, the
//   changes of function calls can be summarized as
//     construction:  allocVector    <--> allocList
//     type checking: isNewList      <--> isList
//     member access: VECTOR_ELT     <--> CAD, CAR, etc
//     member access: SET_VECTOR_ELT <--> ?
//
// Gang Liang
/////////////////////////////////////////////////////////////////

#ifndef R_LIST_H_INCLUDED__
#define R_LIST_H_INCLUDED__

class rlist : public robject {
 public:
  // constructors
  rlist( SEXP sexp );
  rlist( int size );
  rlist( int n, const std::vector<std::string>& strnames );
  
  // helpers: list member attributes
  int size(void) const { return size_; }

  // interfaces for manipulating lists elments
  // it is through SEXP: compromise...
  void setElement( int index, SEXP sexp );
  void setElement( const std::string& name, SEXP sexp );
  SEXP getElement( int  index );
  SEXP getElement( const std::string& name );
  const SEXP getElement( int  index ) const;
  const SEXP getElement( const std::string& name ) const;
  SEXP operator[](int  index)
    { return getElement(index); }
  SEXP operator[](const std::string& name)
    { return getElement(name); }
  const SEXP operator[](int  index) const
    { return getElement(index); }
  const SEXP operator[](const std::string& name) const
    { return getElement(name); }

  // helpers: set/get list names
  const std::vector<std::string>& getNames( void ) const { return names_; }
  void setName( int index, const std::string& name );

 private:
  int size_;
  std::vector<std::string> names_;
};
  
/////////////////////////////////////////////////////////////////////////////
// CTORs

rlist::rlist(SEXP sexp) : robject(sexp)
{
  if( !isNewList(sexp_) )
    throw std::runtime_error( "rlist::rlist(): sexp not a list object.\n" );

  size_ = LENGTH(sexp_);
  names_.resize(size_);

  SEXP names = getAttrib(sexp_,R_NamesSymbol);
  if ( names != R_NilValue ) {
    for( int i = 0; i < size_; i++ )
    {
      SEXP name = STRING_ELT(names,i);
      if ( name != R_NilValue ) names_[i] = CHAR(name);
    }
  }
}

rlist::rlist(int size) : size_(size)
{
  PROTECT( sexp_ = allocVector(VECSXP, size) );
  names_.resize(size_);
  setCreatedBit();
  setRObjectBit();
}

// construct a list oject by given a sequence of SEXP objects
rlist::rlist(int size, const std::vector<std::string>& strnames) :
  size_(size), names_(strnames)
{
  if( strnames.size() != (unsigned)size )
    throw std::runtime_error( "rlist::rlist: the length of names not match list size." );

  PROTECT( sexp_ = allocVector(VECSXP, size) );
  setCreatedBit();
  setRObjectBit();

  setNames(strnames);
}

/////////////////////////////////////////////////////////////////
// helpers: member access

SEXP rlist::getElement( int index )
{
  if( index <0 || index >= size_ )
    throw std::range_error( "rlist::getElement: index out of range.\n" );

  return VECTOR_ELT(sexp_, index);
}

const SEXP rlist::getElement( int index ) const
{
  if( index <0 || index >= size_ )
    throw std::range_error( "rlist::getElement: index out of range.\n" );

  return VECTOR_ELT(sexp_, index);
}

SEXP rlist::getElement( const std::string& name )
{
  for( int i = 0; i < size_; ++i )
  {
    if( name == names_[i] )
      return VECTOR_ELT( sexp_, i );
  }

  // if not found, return NULL as default value.
  return R_NilValue;
}

const SEXP rlist::getElement( const std::string& name ) const
{
  for( int i = 0; i < size_; ++i )
  {
    if( name == names_[i] )
      return VECTOR_ELT( sexp_, i );
  }

  // if not found, return NULL as default value.
  return R_NilValue;
}

void rlist::setElement( int index, SEXP sexp )
{
  if( index <0 || index > length(sexp_) )
    sexp_ = lengthgets( sexp_, index );
  SET_VECTOR_ELT(sexp_, index, sexp);
}

void rlist::setElement( const std::string& name, SEXP sexp )
{
  SEXP names = getAttrib( sexp_, R_NamesSymbol );
  for( int i = 0; i < length(names); i++ ) {
    if( name == CHAR(STRING_ELT(names,i)) ) {
      SET_VECTOR_ELT( sexp_, i, sexp );
      return;
    }
  }

  std::string err = "rlist::setElement: ";
  throw std::runtime_error( err + name + " not found." );
}

/////////////////////////////////////////////////////////////////
// helpers: attributes access

void rlist::setName(int index, const std::string& name)
{
  if( index <0 || index >= size_ )
    throw std::range_error( "rlist::setName: index out of range." );

  names_[index] = name;
  setNames(names_);
}

#endif //R_LIST_H_INCLUDED__
