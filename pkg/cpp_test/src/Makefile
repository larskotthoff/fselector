.PHONY: clean

all: demo_df.so demo_date.so demo_time.so demo_str.so demo_list.so demo_matrix.so

%.so: %.cpp
	R CMD SHLIB $<

clean:
	rm -f *.o *.so
