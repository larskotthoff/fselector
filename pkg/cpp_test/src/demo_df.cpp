#include <rcppbind.h>

RCPP1(demo_df, rdataframe);

SEXP demo_df(const rdataframe& df)
{
  // print the content of the input data.frame
  int ncol = df.ncol();
  int nrow = df.nrow();
  Rprintf( "The input data.frame is: %d by %d\n", nrow, ncol );
  for( int i = 0; i < ncol; i++ ) {
    const rvector<double> temp = df.getColumn<double>(i);
    Rprintf("%2d: ", i);
	const double* iter = temp.begin();
    for( ; iter < temp.end(); ++iter )
      Rprintf( "%5.2f ", *iter );
    Rprintf("\n");
  }

  // return a new data.frame with tow columns: int and double
  std::vector<const std::type_info*> colType(2);
  colType[0] = &typeid(int); colType[1] = &typeid(double);

  std::vector<std::string> colnames(2);
  colnames[0] = "a0"; colnames[1] = "a1";

  rdataframe newdf(5, 2, colType, colnames);
  rvector<int> a0 = newdf.getColumn<int>(0);
  rvector<double> a1 = newdf.getColumn<double>(1);
  for( int i = 0; i < 5; i++ )
  {
    a0[i] = i; a1[i] = i + .5;
  }

  return newdf;
}
