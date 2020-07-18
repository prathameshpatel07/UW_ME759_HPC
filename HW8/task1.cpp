#include <iostream>
#include <chrono>
#include <ratio>
#include <string.h>
#include <omp.h>
#include "matmul.h"

using namespace std;
using namespace chrono;

int main(int argc, char** argv){
  unsigned int n = atoi(argv[1]);
  unsigned int t = atoi(argv[2]);
  float *ar, *bc, *c;
  ar = new float[n*n];
  bc = new float[n*n];
  c = new float[n*n];
  for(unsigned int i = 0; i < n; i++) {
    for(unsigned int j = 0; j < n; j++) {
	//ar[n*i + j] = (float) n*i + j;
	//bc[n*j + i] = (float) n*i + j;
	ar[n*i + j] = (float) n*i + j;
	bc[n*j + i] = (i == j)? 1.0 : 0;
    }
  }
   
  omp_set_num_threads(t); 
  // Get the starting timestamp
	high_resolution_clock::time_point start;
	high_resolution_clock::time_point end;
    	duration<double, std::milli> duration_sec;
	start = high_resolution_clock::now();

	mmul(ar, bc, c, n);

	end = high_resolution_clock::now();
	duration_sec = std::chrono::duration_cast<duration<double, std::milli>>(end - start);

	cout << c[0] << endl;
	cout << c[n*n-1] << endl;
    	cout << duration_sec.count() << endl;

delete[] ar;
delete[] bc;
delete[] c;
return 0;
}
