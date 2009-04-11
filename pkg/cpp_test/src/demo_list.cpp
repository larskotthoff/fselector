#include <rcppbind.h>

RCPP1(demo_list, rlist);

SEXP demo_list(const rlist& list)
{
  // input a list obj: show the content
  const std::vector<std::string> names = list.getNames();
  Rprintf("list size = %d\n", list.size());
  for( int i = 0; i < list.size(); i++ )
  {
    Rprintf("$%s[%d]:\n", names[i].c_str(), i);
    PrintValue(list[i]);
  }

  // new list: two rvectors and a NULL object
  rvector<int> a(3);
  a = 4;

  rvector<double> b(4);
  b = 3.2; b[3] = 5;

  rmatrix<double> c(5, 2);
  c = 1.5; c(3,1) = 3; // indeed c[4,2] = 3

  std::vector<std::string> strnames(3);
  strnames[0] = "a";
  strnames[1] = "b";
  strnames[2] = "c";

  rlist retobj(3, strnames);
  retobj.setElement(0, a);
  retobj.setElement(1, b);
  retobj.setElement(1, c);

  return retobj;
}
