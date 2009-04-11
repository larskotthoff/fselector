// rstring.h
//   rstring: a wrapper class of R CHARSXP object; it is used
//   to as a bridge to manipulate char* objects. Note it is
//   not derived from robject
//
// Gang Liang
/////////////////////////////////////////////////////////////////

#ifndef R_STRING_H_INCLUDED__
#define R_STRING_H_INCLUDED__

class rstring
{
  public:
    rstring(SEXP sexp);                    // wrap an existing string object
    rstring(const char* str) : sexp_(mkChar(str)) {} // create a new rstring
	operator SEXP() { return sexp_; }
	operator const SEXP() const { return sexp_; }

    // make sure no one is using the string b4 assignment
    rstring& operator = (const char* str);
    rstring& operator = (rstring& obj);

    // helper: content access functions
    operator const char*(void) const { return CHAR(sexp_); }
    const char* c_str(void) const { return CHAR(sexp_); }
  private:
	SEXP sexp_;
};

rstring::rstring(SEXP sexp) : sexp_(sexp)
{
  if( TYPEOF(sexp) != CHARSXP )
    throw std::runtime_error( "rstring::rstring: 'CHARSXP' expected." );
}

rstring& rstring::operator = (const char* str)
{
  sexp_ = mkChar(str);
  return *this;
}

rstring& rstring::operator = (rstring& obj)
{
  sexp_ = obj.sexp_;
  return *this;
}

#endif // R_STRING_H_INCLUDED__
