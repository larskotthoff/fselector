// robject.h
//   base class for R object wrapper classes
//
// Gang Liang
/////////////////////////////////////////////////////////////////


#ifndef R_OBJECT_H_INCLUDED__
#define R_OBJECT_H_INCLUDED__

class robject {
 public:
  robject(void) { sexp_ = R_NilValue; state_ = 0; }
  robject(SEXP sexp) : sexp_(sexp) { state_ = 0; setRObjectBit(); }
  virtual ~robject(void)
    { if (isCreated() && isRObject()) UNPROTECT_PTR(sexp_); }

  // helper: SEXP type manipulation
  static SEXPTYPE typeSEXP( const std::type_info& type );

  // SEXP object interface
  operator SEXP(void);
  operator const SEXP(void) const;

  // helpers: Robject manipulation
  void setClass(const char* str) { setClass(sexp_, str); }
  void setNames(const std::vector<std::string>& names) { setNames(sexp_, names); }
  void setRowNames(const std::vector<std::string>& names) { setRowNames(sexp_, names); }
  void setRowNames(int nrow) { setRowNames(sexp_, nrow); }
  
  static void setClass(SEXP sexp, const char* str);
  static void setNames(SEXP sexp, const std::vector<std::string>& names);
  static void setRowNames(SEXP sexp, const std::vector<std::string>& names);
  static void setRowNames(SEXP sexp, int nrow);

 protected:
  // helpers: object attributes manipulation
  int isRObject( void ) const { return state_ & ROBJECT; }
  int isCreated( void ) const { return state_ & CREATED; }
  void setRObjectBit( void ) { state_ |= ROBJECT; }
  void setCreatedBit( void ) { state_ |= CREATED; }

  SEXP sexp_;

 private:
  enum { ROBJECT = 0x1, CREATED = 0x2 };
  int state_;
};

SEXPTYPE robject::typeSEXP( const std::type_info& type )
{
  // 'factor', 'ordered', 'date' are not native types in R
  if (type == typeid(double))
    return REALSXP;
  else if (type == typeid(Rcomplex))
    return CPLXSXP;
  else if (type == typeid(int))
    return INTSXP;
  else if (type == typeid(rstring))
    return STRSXP;
  else if (type == typeid(rdate))
    return INTSXP;
  else if (type == typeid(rtime))
    return REALSXP;

  throw std::logic_error( "robject: unsupported SEXPTYPE." );
  return -1; // -Wall
}

robject::operator SEXP( void )
{
  if(!isRObject())
    throw std::logic_error( "robject::sexp: Not a R object." );

  return sexp_;
}

robject::operator const SEXP( void ) const
{
  if(!isRObject())
    throw std::logic_error( "robject::sexp: Not a R object." );

  return sexp_;
}

void robject::setClass(SEXP sexp, const char* str)
{
  SEXP strclass;
  PROTECT( strclass = allocVector(STRSXP, 1));
  SET_STRING_ELT(strclass, 0, mkChar(str));
  setAttrib(sexp, R_ClassSymbol, strclass);
  UNPROTECT(1);
}

void robject::setNames(SEXP sexp, const std::vector<std::string>& strnames)
{
  // set the names attr
  SEXP names;
  int size = strnames.size();
  PROTECT(names = allocVector(STRSXP, size));
  for( int i = 0; i < size; ++i )
    SET_STRING_ELT(names, i, mkChar(strnames[i].c_str()));

  setAttrib(sexp, R_NamesSymbol, names);
  UNPROTECT(1);
}

void robject::setRowNames(SEXP sexp, const std::vector<std::string>& strnames)
{
  // set the rownames attr
  SEXP names;
  int nrow = strnames.size();
  PROTECT(names = allocVector(STRSXP, nrow));
  for( int i = 0; i < nrow; ++i )
    SET_STRING_ELT(names, i, mkChar(strnames[i].c_str()));

  setAttrib(sexp, R_RowNamesSymbol, names);
  UNPROTECT(1);
}

void robject::setRowNames(SEXP sexp, int nrow)
{
  // set the row.names attr using the compact representation
  // See row_names_gets in main/attrib.c
  SEXP rownames;

  PROTECT(rownames = allocVector(INTSXP, 2));
  INTEGER(rownames)[0] = NA_INTEGER;
  INTEGER(rownames)[1] = nrow;
  setAttrib(sexp, R_RowNamesSymbol, rownames);
  UNPROTECT(1);
}

#endif // R_OBJECT_H_INCLUDED__
