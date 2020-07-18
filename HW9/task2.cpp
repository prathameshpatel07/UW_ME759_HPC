#include <iostream>
#include <cstdlib>
#include <algorithm>
#include <chrono>
#include <ratio>
#include <string.h>
#include <omp.h>
#include "montecarlo.h"

using namespace std;
using namespace chrono;

int main(int argc, char** argv){
  size_t n = atoi(argv[1]);
  unsigned int t = atoi(argv[2]);
  float *x, *y;
  int incircle;
  float r = 1.0;
  x = new float[n];
  y = new float[n];
 
  for(size_t i = 0; i < n; i++) {
	x[i] = 2*((((float) rand()) / (float) RAND_MAX)) - r;
	y[i] = 2*((((float) rand()) / (float) RAND_MAX)) - r;
  }
  omp_set_num_threads(t); 
  // Get the starting timestamp
  duration<double, std::milli> duration_sec_avg;
  high_resolution_clock::time_point dummy;
  dummy = high_resolution_clock::now();
  duration_sec_avg = std::chrono::duration_cast<duration<double, std::milli>>(dummy - dummy);
  for(int j = 0; j < 10; j++) {
	incircle = 0;
	high_resolution_clock::time_point start;
	high_resolution_clock::time_point end;
    	duration<double, std::milli> duration_sec;
	start = high_resolution_clock::now();

	incircle = montecarlo(n, x, y, r);

	end = high_resolution_clock::now();
	duration_sec = std::chrono::duration_cast<duration<double, std::milli>>(end - start);
	duration_sec_avg += duration_sec;
  }
  float pi = 0;
  pi = (4.0*incircle)/n;
        cout << pi << endl;
    	cout << duration_sec_avg.count()/10 << endl;

delete[] x;
delete[] y;
return 0;
}
