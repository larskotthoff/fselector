#include <rcppbind.h>

RCPP1(demo_matrix, rmatrix<double>);

SEXP demo_matrix(const rmatrix<double>& mat)
{
  // show the content of the matrix
  Rprintf( "matrix[%d,%d]\n", mat.nrow(), mat.ncol() );

  // return a new matrix of 5 x 4 (double)
  rmatrix<double> retobj(5, 4);
  retobj = 2; retobj(3,2) = 1; // (3,2) is (4,3) in R

  return retobj;
}
