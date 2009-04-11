// rcomplex.h
//   some operators for Rcomplex object
//
// Gang Liang
/////////////////////////////////////////////////////////////////


#ifndef R_COMPLEX_H_INCLUDED__
#define R_COMPLEX_H_INCLUDED__

inline Rcomplex& operator += ( Rcomplex& left, const Rcomplex& right );
inline Rcomplex& operator -= ( Rcomplex& left, const Rcomplex& right );
inline Rcomplex& operator *= ( Rcomplex& left, const Rcomplex& right );

Rcomplex& operator += ( Rcomplex& left, const Rcomplex& right )
{
  left.r += right.r;
  left.i += right.i;
  return left;
}

Rcomplex& operator -= ( Rcomplex& left, const Rcomplex& right )
{
  left.r -= right.r;
  left.i -= right.i;
  return left;
}

Rcomplex& operator *= ( Rcomplex& left, const Rcomplex& right )
{
  double r = left.r;
  double i = left.i;

  left.r = r * right.r - i * right.i;
  left.i = r * right.i + i * right.r;

  return left;
}

#endif // R_COMPLEX_H_INCLUDED__
